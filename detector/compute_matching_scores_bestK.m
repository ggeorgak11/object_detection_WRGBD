function [scoresK,scoresK_id] = compute_matching_scores_bestK(fea, codes, codes_weight, params)
%compute matching score between test features and codebook features

if(params.mask_fcn)
    [scoresK,scoresK_id] = mex_compute_mscores_K_chi2(fea, codes, codes_weight, params.K, params.sum_total_thresh);
else
    fea_sum = sum(fea,2);
    fea	= spmtimesd(sparse(fea),1./fea_sum,[]);
    fea = full(fea);
    [scoresK,scoresK_id] = hist_cost_chi2(fea, codes, params.K);
end

