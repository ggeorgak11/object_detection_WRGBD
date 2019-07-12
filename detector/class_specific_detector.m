function obj_detector = class_specific_detector(img, edge_map, theta_map, depth,codebook, large_planes, params, segments, objstr)

% Input:    
%           img 
%           edge_map, theta_map (outputs of get_edge())
%           depth
%           codebook 
%           large planes (output of get_support_surface())
%           params (init_params.m)
%           segments (output of form_segments())
%           objstr (string of object category)
% Output:
%           obj_detector (struct that contains the hypotheses)

% Georgios Georgakis 2016

% synthesize the global sampling mask from the segments
% use the sampling area indicator to reduce unnecessary edges in the image
global_area = zeros(size(img,1),size(img,2));
for s=1:size(segments,2), global_area = global_area + segments{s}.mask; end
sampling_mask = imdilate(global_area, strel('disk',7));
edge_map = edge_map.*sampling_mask;
theta_map = theta_map.*sampling_mask;
depth = depth.*sampling_mask;
    
[imgh,imgw] = size(edge_map);

testpos = sample_test_location_on_edges(edge_map, depth, params.sample_step, params.edge_thresh);
if isempty(testpos)
    obj_detector = [];
    return;
end

% Extract features
[fea, fea_sum, testpos] = get_test_features(codebook, testpos, edge_map, theta_map, depth, params);
%disp('Feature extraction done');
% Feature matching
fea = double(fea);   
[scoresK, scoresK_id] = compute_matching_scores_bestK(fea, codebook.codes, codebook.sc_weight, params);
%disp('Matching done');

% prune votes based on matching score
[valid_vote_idx, params] = keep_good_matches(scoresK, params, objstr);

% get candidate positions, use depth also to resize the relpos
[candidate_pos, scaled_relpos] = get_candidate_pos_depth(valid_vote_idx, scoresK_id, codebook, testpos, depth, params, img);

% prune votes that have direction outside of their object proposal(segments)
[candidate_pos, valid_vote_idx] = proposal_ownership(segments, img, testpos, candidate_pos, valid_vote_idx, params, depth);

params.obj_height = codebook.annolist(1).pixel_h; % approx height of the object class
params.obj_aspect_ratio = codebook.annolist(1).pixel_ar; % approx aspect ratio of the object class

[hypo_list, score_list, vote_map] = get_hypo_center(candidate_pos, scoresK, [imgh,imgw], valid_vote_idx, scaled_relpos, params);

% cluster hypo centers to avoid problems from deformations
[hypo_list, score_list] = clusterHypo(hypo_list, score_list, [], params);

% trace back to find voters for each hypo
[vote_record,valid_hypo_idx] = trace_back_vote_record(hypo_list, candidate_pos, params);

hypo_list   = hypo_list(valid_hypo_idx,:);
score_list  = score_list(valid_hypo_idx);

if isempty(hypo_list)
    obj_detector = [];
    return;  
end

%%%%% save results for post processing %%%%%%%%%%%
obj_detector.imgsz = [imgh,imgw];
obj_detector.testpos = testpos;
obj_detector.features = fea;
obj_detector.scoresK = scoresK;
obj_detector.scoresK_id   = scoresK_id;
obj_detector.candidate_pos = candidate_pos;
obj_detector.vote_record  = vote_record;
obj_detector.vote_map = vote_map;
obj_detector.hypo_list = hypo_list;
obj_detector.score_list = score_list;
obj_detector.valid_vote_idx = valid_vote_idx;    

% generate a bbox for each hypo
obj_detector = generate_bbox(obj_detector);

% remove hypos that were formed on any large surfaces (their center)
for h=1:size(obj_detector.hypo_list,1)
    hypo_coord = obj_detector.hypo_list(h,:);
    if (large_planes(hypo_coord(2), hypo_coord(1)) == 1), obj_detector.score_list(h) = 0; end;
end
valid_list = find(obj_detector.score_list > 0);
obj_detector = keep_valid(obj_detector, valid_list);

% non maximum suppresion
valid_hypo_idx  = prune_by_area_overlapping(obj_detector.hypo_bbox, obj_detector.score_list);
if (length(valid_hypo_idx) < size(obj_detector.hypo_list,1))
    fprintf(1,'\t hypotheses pruned because of area overlap %d\n', size(obj_detector.hypo_list,1)-length(valid_hypo_idx));  
end    
obj_detector = keep_valid(obj_detector, valid_hypo_idx);

% remove hypos that have bbox width or height <=thresh
bb=obj_detector.hypo_bbox;
width=bb(:,3)-bb(:,1); height=bb(:,4)-bb(:,2);
valid=find(width>params.min_hypo_size & height>params.min_hypo_size);
if (length(valid) < size(obj_detector.hypo_bbox,1))
    fprintf(1,'\t hypotheses pruned because of low width,height %d\n', size(obj_detector.hypo_bbox,1)-length(valid));  
end
obj_detector = keep_valid(obj_detector, valid);  

% sort hypos based on score
obj_detector = sort_hypos(obj_detector);

% given the pose_id of each voter, present a histogram of the rough estimated poses of each hypo.
% Optional part 
% obj_detector = pose_prediction(obj_detector, codebook, params);
end
    
