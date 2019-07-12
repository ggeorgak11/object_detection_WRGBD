



function recog_result = sort_hypos(recog_result)

[v,ind]=sort(recog_result.score_list,'descend');
recog_result.score_list = recog_result.score_list(ind);
recog_result.vote_record = recog_result.vote_record(ind);
recog_result.hypo_list = recog_result.hypo_list(ind,:);
recog_result.hypo_bbox = recog_result.hypo_bbox(ind,:);
%recog_result.hypo_mask = recog_result.hypo_mask(:,:,ind);
%recog_result.mask_heights = recog_result.mask_heights(ind);
%recog_result.vote_coverage = recog_result.vote_coverage(ind);
%recog_result.pose_img_id = recog_result.pose_img_id(ind,:);