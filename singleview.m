close all; clear all; clc;

% Single-view multiclass prediction for scenes of WRGB-D scenes dataset V2
% Georgios Georgakis 2016

set_paths;
set_init_params;

objstr_list = {'bowl', 'cap', 'cereal_box', 'coffee_mug', 'soda_can', 'background'};
lc = length(objstr_list);
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

        % function for multi-class prediction
        [vhypos, segments] = multiclass_detection(params, img, depth, edge_map, theta_map, objstr_list, cb_path);
        if isempty(segments), continue; end;

        test_info = bboxes{str2double(frame_ind)}; %get info of test image
        gtBB = get_gtBBoxes(test_info, 0, '', ''); 

        [confusion, ~] = getConfusionMatrix(vhypos, test_info, gtBB, objstr_list, segments, params.over_thresh);

        res = zeros(length(objstr_list),4); % tp fp tn fn
        for i=1:length(objstr_list)
            res(i,1) = confusion(i,i); % tp
            res(i,2) = sum(confusion(i,:)) - confusion(i,i); % fp
            res(i,3) = sum(diag(confusion)) - confusion(i,i); % tn
            res(i,4) = sum(confusion(:,i)) - confusion(i,i); % fn
        end

        % get total confusion matrix over all frames and scenes
        total_res = total_res + res;
        total_conf(2:lc+1,2:lc+1) = total_conf(2:lc+1,2:lc+1) + confusion;

    end        


end

% write precision-recall for all the scenes
get_write_pr(total_conf, total_res, objstr_list, 0, output_path, params.write_results, params.verbose);


seconds=toc(timerVal)
elapsed_time_minutes=seconds/60 




