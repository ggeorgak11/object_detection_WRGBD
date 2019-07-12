% keep only the valid hypos with all corresponding information

function obj_result = keep_valid(obj_result, valid_hypo_idx)

obj_result.hypo_list = round(obj_result.hypo_list(valid_hypo_idx,:));
obj_result.score_list = obj_result.score_list(valid_hypo_idx);
obj_result.hypo_bbox = round(obj_result.hypo_bbox(valid_hypo_idx,:));
obj_result.vote_record = obj_result.vote_record(valid_hypo_idx);
%obj_result.hypo_mask = obj_result.hypo_mask(:,:,valid_hypo_idx);
%obj_result.mask_heights = obj_result.mask_heights(valid_hypo_idx);
%obj_result.vote_coverage = obj_result.vote_coverage(valid_hypo_idx);
%obj_result.pose_img_id = obj_result.pose_img_id(valid_hypo_idx,:);
