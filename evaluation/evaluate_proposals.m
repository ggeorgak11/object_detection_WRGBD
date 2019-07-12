close all; clear all; clc;

% evaluate the segments(proposals) in terms of recall, on all scenes in the
% WRGB-D scenes v2 dataset.
% Note: need to precalculate the segments and load them in this script

% Georgios Georgakis 2016

set_paths;
set_init_params;

total=0; correct=0; count_proposals=0; count_frames=0;
for sc=1:14
    disp(['- Scene ', num2str(sc)]);
    
    if sc<10, scene_path = [dataroot, 'rgbd-scenes-v2/imgs/scene_0', num2str(sc)]; scene_num = ['0',num2str(sc)]; 
    else scene_path = [dataroot, 'rgbd-scenes-v2/imgs/scene_', num2str(sc)]; scene_num = num2str(sc);  end
    
    % load the ground truth poses given by the dataset v2 
    scene_info_path = [dataroot, 'rgbd-scenes-v2_info/pc/', scene_num];
    poses = load([scene_info_path, '.pose']);
    
    % load the bounding box annotations for the current scene
    % the annotations where created by projecting the 3d labels onto the individual frames
    load([dataroot, 'rgbd-scenes-v2/annotation/scene_', scene_num, '_info.mat']); % loads bboxes  
    
    
    for fr=1:5:size(bboxes,2) % test on every 5th frame
    %for fr=61:61
        frame_ind = num2str(fr);
        %disp(' ');
        %disp(['-- frame ', frame_ind]);
        
        file = get_file_path(fr, scene_path);
        img = imread([file, '-color.png']); 
        %figure; imagesc(img);
        
        %load([file, '_segments2.mat']); % loads segments, [left top right bottom]
        
        count_proposals = count_proposals + size(segments,2);
        count_frames = count_frames + 1;
        
        proposals = [];
        for i=1:size(segments,2)
            bb = segments{i}.bb;
            proposals(i,:) = [bb(1) bb(2) bb(3)-bb(1) bb(4)-bb(2)];
        end
        
        test_info = bboxes{str2double(num2str(fr))}; %get info of test image
        gtBB = get_gtBBoxes(test_info, 0, '', '');
        
        for i=1:size(gtBB,1)
            total=total+1;
            gtbb_area = gtBB(i,3)*gtBB(i,4);
            % visualize the ground truth
            %if vis_flag, rectangle('position', gtbb, 'EdgeColor','b', 'LineWidth', 2); end

            intersection = rectint(gtBB(i,:), proposals)';
            areas = proposals(:,3).*proposals(:,4);
            den = areas + gtbb_area - intersection;
            overlap = intersection ./ den;
            goodbbs = find(overlap>=params.over_thresh);
            if isempty(goodbbs), continue; end % no overlap found
            correct=correct+1;
        end
        
        
    end
    
    
end

recall = correct / total
precision = total / count_proposals
nproposals = count_proposals / count_frames



