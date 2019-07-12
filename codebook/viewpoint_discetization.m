close all; clear all; clc

% Read through the image files of each object instance and group them based on their viewpoints.
% Creates data file that contains a structure of size horz_nViews*3.
% Images of the object instances are in datasetV1 path (look set_paths). The pose.txt files for
% the objects must also be downloaded from the dataset website and extracted in their respected
% object instances folders.

% Georgios Georgakis 2016

set_paths;
objstr = 'cap'; % choose the object category (e.g. bowl, cap, ...)
objinst_list = {'1', '2', '3', '4', '5', '6'};
if ~exist(data_struct_path, 'dir'), mkdir(data_struct_path); end

horz_nViews = 6; % total views is horz_nViews * 3 because of the three vertical angles
visualize=0; % creates a visualization at the end

for inst = 1:length(objinst_list)
    objinst = objinst_list{inst};
    path = [datarootV1, 'rgbd-dataset/', objstr, '/', objstr, '_', objinst, '/'];
    out_file = [data_struct_path, objstr, '_', objinst, '_viewpoints', num2str(horz_nViews*3),'_data.mat'];
    %out_file = [datarootV1, '/rgbd_dataset/', objstr, '/', objstr, '_', objinst, '_viewpoints', num2str(horz_nViews*3),'_data.mat'];

    if ~exist(out_file, 'file')
        file_counter = 0; vert_angle_counter = 1; c=0; change_of_angle = true;
        while(1)
        %for i=1:1   
            % files are separated into three groups 30(1),45(2),60(4) degrees vertical angle    
            file_counter = file_counter + 1;
            file_name = [objstr, '_', objinst, '_', num2str(vert_angle_counter), '_', num2str(file_counter), '_crop.png'];
            file_rgb = [path, file_name];
            %keyboard
            if (exist(file_rgb, 'file') == 0) 
                vert_angle_counter = vert_angle_counter + 1;
                c=0;
                file_counter = 0;
                if vert_angle_counter > 4
                    break;
                end       
                continue;
            end

            c = c + 1
            if vert_angle_counter==1; angle=30; angle_id=1;
            elseif vert_angle_counter==2; angle=45; angle_id=2;
            else angle=60; angle_id=3;
            end

            file_mask = [path, objstr, '_', objinst, '_', num2str(vert_angle_counter), '_', num2str(file_counter), '_maskcrop.png'];
            file_loc = [path, objstr, '_', objinst, '_', num2str(vert_angle_counter), '_', num2str(file_counter), '_loc.txt'];
            file_pose = [path, objstr, '_', objinst, '_', num2str(vert_angle_counter), '_', num2str(file_counter), '_pose.txt'];

            img = imread(file_rgb);
            mask = imread(file_mask);
            loc = load(file_loc);
            if exist(file_pose, 'file')
               pose = load(file_pose); % in degrees
            else
               pose = annolist(angle_id,c-1).pose;
            end

            % do filled depth if needed
            file_filledDepth = [path, objstr, '_', objinst, '_', num2str(vert_angle_counter), '_', num2str(file_counter), '_filledDepth.mat'];
            if ~exist(file_filledDepth, 'file')
                file_depth = [path, objstr, '_', objinst, '_', num2str(vert_angle_counter), '_', num2str(file_counter), '_depthcrop.png'];
                depth = imread(file_depth); depth = double(depth);
                depth = fill_depth_colorization(double(img)/255, depth/1e3); %From the NYU-V2 toolbox 
                depth = round(depth*1e3);
                save(file_filledDepth, 'depth');
            else
                load(file_filledDepth) % loads depth
            end

            %keyboard
            annolist(angle_id,c).img = img;
            annolist(angle_id,c).name = file_name;
            annolist(angle_id,c).mask = mask;
            annolist(angle_id,c).loc = loc;
            annolist(angle_id,c).depth = depth;
            annolist(angle_id,c).pose = pose;
            annolist(angle_id,c).angle = angle;    
        end

        pose_id = 0; pose_index = 0;
        for angle_id=1:3;
            % discretize the views in bins
            view1 = annolist(angle_id,:);
            %deg_range=20;
            deg_range = round(360/horz_nViews);
            %nViews = round(360/deg_range);
            min_deg = 0; 
            max_deg = min_deg + deg_range;
            % for d=0:20:360
            for v=1:horz_nViews
                p=0;
                for i=1:size(view1,2)       
                    if ~isempty(view1(i).img)
                        cur_pose = view1(i).pose;
                        if (cur_pose < max_deg) && (cur_pose >= min_deg)
                            p=p+1;
                            view_list(v,p) = i; % mark which images correspond to which bin
                        end
                    end
                end
                min_deg = min_deg + deg_range;
                max_deg = min_deg + deg_range;
            end

            % view_list contains the indexes corresponding to annolist for each
            % image that belongs to a certain viewpoint
            for vi = 1:size(view_list,1)
                pose_id = pose_id + 1;
                curr_view = view_list(vi,:);
                curr_view = curr_view(curr_view~=0);
                if ~isempty(curr_view)
                    for i=1:length(curr_view)
                        index = curr_view(i);
                        info(i).img = annolist(angle_id, index).img;
                        info(i).name = annolist(angle_id, index).name;
                        info(i).mask = annolist(angle_id, index).mask;
                        info(i).loc = annolist(angle_id, index).loc;
                        info(i).depth = annolist(angle_id, index).depth;
                        info(i).azimuth = annolist(angle_id, index).pose;
                        info(i).elevation = annolist(angle_id, index).angle;
                        info(i).pose_id = pose_id;
                    end
                else
                    info = [];
                end
                pose_index = pose_index + 1;
                viewpoints(pose_index).info = info;
                %viewpoints(angle_id, vi).info = info;
                clearvars info;
            end
            clearvars view_list;
        end

        save(out_file, 'viewpoints');
        clearvars annolist;
        clearvars viewpoints;
        
    end        
    load(out_file); % loads viewpoints
    
    if visualize
        % visualize the viewpoints
        %for id=1:3
            for v=1:size(viewpoints,2)
               %info = viewpoints(id,v).info;
               info = viewpoints(v).info;
               figure;
               suptitle(['pose id: ', num2str(v)]);
               row=3;
               col = ceil(size(info,2) / row);
               for i=1:size(info,2)
                  subplot(row,col,i);
                  imagesc(info(i).img);
                  %axis image
                  title(num2str(info(i).azimuth));
               end 
               pause;
               close all;
            end
        %end
    end


end






