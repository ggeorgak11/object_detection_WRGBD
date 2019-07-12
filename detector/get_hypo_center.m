function [hypo_list,score_list, vote_map] = get_hypo_center(candidate_pos,match_scoreK,imgsz,valid_match_idx,...
    scaled_relpos, params)

% Liming Wang 2008
% Edited by Georgios Georgakis 2016

vote_offset = max(max(abs(scaled_relpos))) + 5; %need to compute again the vote_offset because of the scaled_relpos
vote_offset  = round(vote_offset);
sx  = vote_offset;
sy  = vote_offset;
if isempty(candidate_pos)
    candidate_pos_x=[];
    candidate_pos_y=[];
else
    candidate_pos_x = candidate_pos(:,1)+sx;
    candidate_pos_y = candidate_pos(:,2)+sy;
end

density_map1  = sparse(candidate_pos_y,candidate_pos_x,...
    match_scoreK(valid_match_idx),...
    imgsz(1)+2*vote_offset,imgsz(2)+2*vote_offset);

VR = full(density_map1);

voter_filter = compute_smth_kernel(params.obj_height, params.obj_aspect_ratio);
voter_filter = voter_filter{1}; % filter is used to collect votes from voters
VR = conv2(VR, voter_filter, 'same');
vote_map	= VR(sy+1:sy+imgsz(1),sx+1:sx+imgsz(2));

[hypo_list, score_list, ~] = get_hypo_from_votemap(vote_map, params.hypo_thresh);

figure; if ~params.figs_visible, set(gcf,'Visible', 'off'); end
imagesc(vote_map); title('heat map');
    

