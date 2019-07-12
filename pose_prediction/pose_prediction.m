

function [recog_result] = pose_prediction(recog_result, codebook, params)

% given the pose_id of each voter, present a histogram of the rough
% estimated poses of each hypo and decide on its pose id
% Georgios Georgakis 2016

nb_test = size(recog_result.testpos,1);
recog_result.pose_img_id = zeros(size(recog_result.hypo_list,1),2);

%for hy=1:size(recog_result.hypo_list,1)
for hy=1:size(recog_result.hypo_list,1)
    idx_code_curhypo= recog_result.vote_record(hy).voter_id;
    idx_code_curhypo= recog_result.valid_vote_idx(idx_code_curhypo);
    idx_fea_curhypo = mod(idx_code_curhypo-1, nb_test) + 1; % feature id
    codes_ids = recog_result.scoresK_id(idx_fea_curhypo); % matched codebook entries
    codes_pose_ids = codebook.pose_id(codes_ids); % pose ids of the matched codebook entries
    
    pose_hist = hist(codes_pose_ids, 1:params.nViews);
    
    % use the two dominant poses to evaluate the pose prediction.
    % use the codebook entries to determine azimuth and elevation
    [V, sorted_ind]=sort(pose_hist, 'descend');
    nonZeros = size(find(pose_hist>0),2);
    
    max_pose_id = sorted_ind(1);
    sec_max_pose_id = sorted_ind(2);
    
    img_id1 = get_closest_image(max_pose_id, codebook, codes_ids, params.figs_visible);
    img_id2=0; % initialize just in case
    if nonZeros > 1
        img_id2 = get_closest_image(sec_max_pose_id, codebook, codes_ids, params.figs_visible);
    end
    
    % store the img ids of the two closest predicted poses
    recog_result.pose_img_id(hy,:) = [img_id1 img_id2];
    
end
 
