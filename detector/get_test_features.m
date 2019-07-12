
function [fea, fea_sum, testpos] = get_test_features(codebook, testpos, edge_map, theta_map, depth, params)

%%%%%% Depth-adaptive shape contexts %%%%%%
% the extend of each SC extracted at each test point depends on the
% depth ratio of the test point and the object from training

% Georgios Georgakis 2016

info = codebook.annolist;
for i=1:size(info,1)
    med_z(i) = info(i).median_Z;
end
z = median(med_z); % median depth of the object from training
%tr_bins = codebook.para.bin_r; % radial bins of SC from training
tr_bins = params.bin_r;

fea = []; fea_sum = [];
for i=1:size(testpos,1)
%for i=1:1
    pos = testpos(i,:);
    test_z = sample_depth(depth, pos);
    if test_z==0, z_ratio=1; 
    else z_ratio = z/test_z;
    end
    r_bins = round(tr_bins * z_ratio); % resize the radial bins of the SC
    params.bin_r = r_bins; 
    [fea1, fea_sum1] = extract_sc_feature(edge_map, theta_map, pos, params);
    fea = [fea; fea1]; fea_sum = [fea_sum; fea_sum1];
end
    
fea_idx = find(fea_sum>params.sum_total_thresh);
if ~isempty(fea_idx)
    if(length(fea_idx)<size(fea,1))
        if(params.verbose>1)
            disp(sprintf('prune %d zero test features',size(fea,1)-length(fea_idx)));
        end
        fea     = feature_from_ind(fea,fea_idx);
        fea_sum = feature_from_ind(fea_sum,fea_idx);
        testpos = feature_from_ind(testpos,fea_idx);
        %weight = feature_from_ind(weight,fea_idx);
    end
end