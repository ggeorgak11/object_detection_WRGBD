function [ hypo_list,score_list, winThreshold ] = get_hypo_from_votemap(vote_map, cur_thresh)

region_thresh = 1; 

[imgh,imgw] = size(vote_map);

[winMtx_mask, winThreshold, bias] = winnerPopOut(vote_map, cur_thresh);
bias_thresh = 15;

[winMtx_mask2,nb_clr]   = bwlabel(winMtx_mask,4);
winMtx_mask= dropSmallRegion(winMtx_mask2,nb_clr,region_thresh);
regmin1 = imregionalmax(vote_map);   
regmin = regmin1 & winMtx_mask;
[jj_list, ii_list] = find(regmin);


% avoid to lose the perfect winner because of the region thresholding
if(bias>bias_thresh & isempty(jj_list))
    [unused,max_idx] = max(vote_map(:));
    [jj_list,ii_list] = ind2sub([imgh,imgw],max_idx);
end

score_list = vote_map(jj_list + (ii_list-1)*imgh);
hypo_list = [ii_list, jj_list];
