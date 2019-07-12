clear all; close all; clc

% create a codebook for each object instance that encodes the viewpoint (SC codes come with a pose id)
% This script reads from a pre-computed file [object_objectInstance_viewpoints_nViews_data.mat] 
% which includes a structure of the training data of the specifice object instance grouped based on the pose annotation.
% The pre-computed files for the 6 object categories available in the scenes are provided.
% If it is desired to create codebooks for other objects, run
% viewpoint_discretization.m first, and then this script.

% Georgios Georgakis 2016

set_paths;
set_training_params;
codebook = [];

for obj=1:length(objstr_list)
    objstr = objstr_list{obj} 
    % use different bin_r for each object
    params.bin_r = define_bin_r(objstr);     
    for inst=1:length(objinst_list)
        objinst = objinst_list{inst}  
        
        data_file = [data_struct_path, objstr, '_', objinst, '_viewpoints', num2str(params.nViews),'_data.mat'];
        if exist(data_file, 'file')
            load(data_file); % loads viewpoints
        else
            disp(['Data file for ', objstr, ' ', objinst, ' could not be found!']); continue; 
        end
                 
        instance_codebook = load_codebook_with_viewpoints(viewpoints, params);
        % save instance codebook
        save([cb_inst_path, 'cb_', objstr, '_', objinst, '.mat'], 'instance_codebook');
        
        % create the class codebook by merging the instance_codebooks
        codebook = merge_codebook(codebook, instance_codebook);
    end
        
    % save class codebook
    save([cb_path, 'cb_', objstr, '.mat'], 'codebook');
    
end




