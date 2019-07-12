close all; clear all; clc;

% multiview detection for scenes V2
% Georgios Georgakis 2016

set_paths;
set_init_params;

objstr_list = {'bowl', 'cap', 'cereal_box', 'coffee_mug', 'soda_can', 'background'};
init_prob = ones(length(objstr_list),1)*(1/length(objstr_list));  % initial prob distribution over the objects
total_conf = zeros(length(objstr_list)+1,length(objstr_list)+1);
total_res = zeros(length(objstr_list),4);

timerVal=tic;
% The WRGB-D scenes dataset v2 contains 14 scenes 
for sc=1:14
    disp(['- Scene ', num2str(sc)]);
    
    if sc<10, scene_path = [datarootV2, 'rgbd-scenes-v2/imgs/scene_0', num2str(sc)]; scene_num = ['0',num2str(sc)]; 
    else scene_path = [datarootV2, 'rgbd-scenes-v2/imgs/scene_', num2str(sc)]; scene_num = num2str(sc);  end
    
    % load the ground truth poses given by the dataset v2 
    scene_info_path = [datarootV2, 'rgbd-scenes-v2_info/pc/', scene_num];
    poses = load([scene_info_path, '.pose']);
    
    % load the bounding box annotations for the current scene
    % the annotations where created by projecting the 3d labels onto the individual frames
    load([datarootV2, 'rgbd-scenes-v2/annotation/scene_', scene_num, '_info.mat']); % loads bboxes  
    
    f_ind=0; track_id=0; tracklets=[]; frame=[];
    for fr=1:5:size(bboxes,2) % test on every 5th frame
        frame_ind = num2str(fr);
        disp(' ');
        disp(['-- frame ', frame_ind]);
        
        file = get_file_path(fr, scene_path);
 
        img = imread([file, '-color.png']); %figure; imagesc(img); pause
        depth = imread([file, '-depth.png']); depth=double(depth); depth=depth/10;
        
        [edge_map, theta_map] = get_edge(img, depth, datarootV2, scene_num, frame_ind); 
  
        % perform multi-class detection on a single frame
        [vhypos, segments] = multiclass_detection(params, img, depth, edge_map, theta_map, objstr_list, cb_path);
        if isempty(segments), continue; end;
         
        % map hypos to segments to get segment info
        hypos = hypo_to_segment_assoc(segments, vhypos, length(objstr_list));

        % trasform detector score to probabilities
        hypos = get_prob_of_scores(hypos, params);

        % remove all unnecessary info from the hypos
        % optional, uses less memory
        hypos = remove_hypo_data(hypos);

        % frame struct holds info for each frame in the scene
        f_ind=f_ind+1;
        frame{f_ind}.hypos = hypos;
        frame{f_ind}.ind = frame_ind; % actual index of frame in scene
        frame{f_ind}.frame_path = file;
        % if this is the first frame of the sequence just initialize the tracks on the hypos
        % for each track_id, tracklets struct holds its occurences in the scene
        % assign a track_id to each hypo in the frame struct
        if f_ind==1
            h_temp = frame{f_ind}.hypos;
            for i=1:size(h_temp,2)
                track_id = track_id + 1; % new track initialized
                h_temp{i}.track_id = track_id;
                tracklets{track_id}.flist = f_ind; % save the frame ind that each tracklet appears in
                tracklets{track_id}.hlist = i; % save the hypo id of the frame
                tracklets{track_id}.class_distr = init_prob; % initialize probs
                tracklets{track_id}.prediction = 0; % no prediction yet
                tracklets = update_class_prob(tracklets, track_id, f_ind, i, frame);
            end
            frame{f_ind}.hypos = h_temp;
            continue; 
        end

        hypos1 = frame{1}.hypos;   % hypos from reference frame
        hypos2 = frame{f_ind}.hypos; % hypos from 

        % For each hypo in frame{f_ind} project it back to the origin
        % and compare its 3d centroid to the existing 3d centroids.
        % If a consistent 3d point exist add a new hypo to frame{1}.hypos and update the track
        % Even if a consistent hypo does not exist add it anyway 
        for i=1:size(hypos2,2)
            hy = hypos2{i};                  
            proj_cent = bsxfun(@plus,poses(fr,5:7),quatrotate([poses(fr,1) -poses(fr,2:4)],hy.centroid_3D'))';

            % data association, find distance of proj_cent to 3d points of hypos1
            diff=[];
            for j=1:size(hypos1,2)
                hy1_cent=hypos1{j}.centroid_3D;
                diff(j) = sqrt(sum((hy1_cent-proj_cent).^2));
            end
            [v,min_ind]=min(diff);

            if v <= params.centroid_dist % if projected center is at least 7cm close then associate them 
                id=hypos1{min_ind}.track_id;
                % only the centroid and the track_id are needed in the first frame struct to make further associations 
                hy1.track_id = id;
                hy1.centroid_3D = proj_cent;
                hypos1{end+1} = hy1;

                % If the tracklet already contains an instance in the current frame, then merge the hypos
                if tracklets{id}.flist(end)==f_ind
                    frame = add_hypos(frame, f_ind, objstr_list, tracklets{id}.hlist(end), i);
                else
                    tracklets{id}.flist(end+1) = f_ind;
                    tracklets{id}.hlist(end+1) = i;
                end                    
                % update probabilities of the tracklet using the latest hypo added
                tracklets = update_class_prob(tracklets, id, f_ind, i, frame);

            else % else add it into the hypos of frame1 and begin a new tracklet for it
                track_id=track_id+1;
                hy1.track_id = track_id;
                hy1.centroid_3D = proj_cent;
                hypos1{end+1} = hy1;
                tracklets{track_id}.flist = f_ind;
                tracklets{track_id}.hlist = i;                    
                tracklets{track_id}.class_distr = init_prob; % initialize probs for the new tracklet
                tracklets{track_id}.prediction = 0; % no prediction yet
                tracklets = update_class_prob(tracklets, track_id, f_ind, i, frame);
            end
        end
        
        if params.verbose, disp('Data association and prob update...done'); end
        
        frame{1}.hypos = hypos1; % refresh the new hypos in frame1
        
        if ~params.figs_visible, close all; end;
    end        
    
    % uncomment, or run individually to see the tracks. need to press a key to see next frame    
    %visualize_tracks(tracklets, frame, 80, 1);    
    
    % use the tracklets and their final predictions to calculate the new results
    % populate a struct holding the frames info and then save the vhypos individually
    % frame holds individual frame results, frame_new holds the track results
    frame_new = populate_frame_struct(tracklets, frame, params, objstr_list);    
    if params.save_flag, save([output_path, 'scene_', scene_num,'_info.mat'], 'frame', 'frame_new', 'tracklets'); end
    
    % compute confusion matrix, tp, fp, tn, fn for this scene
    [scene_conf, scene_res] = evaluate_scene(bboxes, frame_new, params, objstr_list, segments);
    % write precision-recall for the scene into a txt file
    get_write_pr(scene_conf, scene_res, objstr_list, sc, output_path, params.write_results, params.verbose);
    
    % get total confusion matrix over all frames and scenes
    total_res = total_res + scene_res;
    lc = length(objstr_list);
    total_conf(2:lc+1,2:lc+1) = total_conf(2:lc+1,2:lc+1) + scene_conf(2:lc+1,2:lc+1);
    
end

% write precision-recall for all the scenes
get_write_pr(total_conf, total_res, objstr_list, 0, output_path, params.write_results, params.verbose);



seconds=toc(timerVal)
elapsed_time_minutes=seconds/60 




