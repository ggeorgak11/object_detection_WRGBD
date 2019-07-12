% All parameters needed for the detection (both multiview, singleview)
% Georgios Georgakis 2016


% general params
params.write_results = 0; % enable to save the experiment results
params.save_flag = 0; % enable to save the tracks and frame info for each scene
params.verbose = 1; % enable to see more messages during runtime
params.figs_visible = 0; % enable this to show figs

% camera
params.focal_length=525; % 525 for V2, 570.3 for V1
params.center=[320 240];

% for the support planes
params.far_thresh = 2500;
params.nPixelsSupport = 27000;
params.gravity_align_thresh = 0.7;
params.plane_size_thresh = 5000;

% min-shift parameter
params.max_z=1200; params.min_z=600; 
params.min_range=0.08; params.max_range=0.13;

% segments
params.pcl_subsample = 2; % cannot be more than 2
params.min_cluster_size = 500/params.pcl_subsample;
params.max_dist_from_support = 0.8; % change to 999 to avoid

% Hypothesis processing
params.min_hypo_size=10;

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
params.edge_thresh = 0;

% Matching
params.mask_fcn = 1; % whether use mask function or not when doing the matching
params.K = 8; % best K matches to be found for each test point

% Voting
params.sample_step=5; % sample from test edge map
params.vote_thresh = 0.85; % minimum score of a match
params.hypo_thresh = 0.0; % local maximum thresh for the hypo formation
params.nb_iter = 2; % the number of iteration to cluster hypothesis
params.elps_ab = 0; % radii used to cluster hypotheses centers, will be defined during detection
params.vote_disc_rad = 0; % radius used for tracing back voters, will be defined during detection
params.obj_height=0; % object height will be approximated during detection
params.obj_aspect_ratio = 0; % object aspect ratio will be approximated during detection
params.nViews = 18; % specify num of viewpoints, if 0 then viewpoints not used

% Multi-class
params.weight_hypo=0;        % enable to weight each hypo based on its overlap with its object proposal
params.over_seg_thresh=0.5;  % 0...1, overlap threshold for pruning hypos
params.prune_hypo=1;         % enable to prune hypos if their overlap with their object proposal is less than over_seg_thresh
params.score_thresh=1; % minimum score of a hypo before score normalization
params.norm_score_thresh=-999; % score thresh after normalization, change the -inf to enable
load('obj_norm_params.mat'); % loads obj_norm_params
params.obj_norm_params = obj_norm_params; % normalization parameters across object classes
params.nms_mode = 'min'; % non-maximum suppression, it can be either 'iou' or 'min'
params.over_thresh = 0.5; % 0...1 overlap thresh for nms

% Multi-view
params.min_v=-10.849; params.max_v=62.7484; % min and max values of detectors found from a validation set
params.background_score=0.1;
params.zero_score=0.01;
params.centroid_dist=0.07; % 7cm thresh for associating hypos between viewpoints 
params.support_per = 0.6; % thresh on the min length of the valid tracks





