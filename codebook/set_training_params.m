

% define the parameters needed for creating the codebooks

% Georgios Georgakis 2016

% Shape context feature parameters
params.bin_r = [0,6,15,35];% radial bins -- will be defined based on each object later
params.nb_bin_theta = 12; % number of angular bins 
params.nb_ori = 4; % number of orientation to split edge
% blurring factors
params.blur_r = 0.2; % blur_r is on radial
params.blur_t = 1.0; % blur_t is angular
params.blur_o = 0.2; % blur_o is edge orientation
params.blur_method = 'gaussian'; % blurring method, take value of ['gaussian'|'cosine']
params.sum_total_thresh = ((length(params.bin_r)-1) * params.nb_bin_theta) / 8 ; % threshold used to prune nearly-zero shape context vector

% parameters for the codebook creation
params.nViews = 18; % choose the number of viewpoints. Make sure the corresponding data file exists!
params.sampling_step = 15; % subsampling of the training images
params.se = strel('disk',7);
params.edge_thresh=0; % edge thresh when sampling points from training image
params.step_length=5; % sample every k edge points

% choose set of objects to create the codebooks
objstr_list = {'bowl', 'soda_can', 'cap', 'flashlight', 'coffee_mug', 'cereal_box'};
objinst_list = {'1', '2', '3', '4', '5', '6'};

