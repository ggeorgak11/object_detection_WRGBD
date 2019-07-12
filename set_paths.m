

% set paths needed
% Georgios Georgakis 2016

% Assuming root directory is the project's main directory
addpath(genpath(pwd));

% this is where the RGBD dataset v2 is located
% ***** the dataset folder should contain our generated annotations in:
% ***** /RGBD_dataset_V2/rgbd-scenes-v2/annotation/
datarootV2 = '../RGBD_dataset_V2/';
addpath(genpath(datarootV2));

% this is needed to access the training images in case you want to create new codebooks
datarootV1 = '../RGBD_dataset/';
addpath(genpath(datarootV1));

% The trained codebooks for each object are located in the codebooks folder in the main directory
% In case new codebooks are created, save them here (older codebooks will be overwritten)
% In the code, the classes codebooks are used
cb_path = 'codebook/codebook_files/'; if ~exist(cb_path,'dir'), mkdir(cb_path); end
cb_inst_path = 'codebook/codebook_files/instances/'; if ~exist(cb_inst_path,'dir'), mkdir(cb_inst_path); end
data_struct_path = 'codebook/data_files/';

% add the pb edge detector path (see README for download)
addpath(genpath('../segbench/')); 

% create the output directory where results are going to be stored
output_path = 'wrgbd_multiview_results/';
if ~exist(output_path, 'dir'), mkdir(output_path); end;




