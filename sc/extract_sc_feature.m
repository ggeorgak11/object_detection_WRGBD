function [fea,fea_sum]  = extract_sc_feature(edge_map,theta_map,testpos,params)
%[fea,fea_sum]  = extract_sc_feature(edge_map,theta_map,testpos,params)
%   extract shape context feature from edge map for point set 'testpos'
%
%INPUT:
%   EDGE_MAP:   edge detection results
%   THETA_MAP:  orientation at each point on edge map
%   TESTPOS:    feature points
%   PARA_SC:    parameter for feature extraction
%
%OUTPUT:
%   FEA:        feature set.
%               [# of feature points x dim of the feature histogram]
%   FEA_SUM:    sum of each feature, used for normalization
%               [# of feature points x 1]
%
%   Liming Wang, Jan 2008
%

[ey,ex] = find(edge_map>params.edge_thresh);
eind    = sub2ind(size(edge_map), ey, ex);

ori     = theta_map(eind);
mag     = edge_map(eind);

%keyboard

fea     = compute_sc(testpos(:,1),testpos(:,2),...
    ex,ey,ori,mag,...
    params.bin_r, params.nb_bin_theta, params.nb_ori,...
    params.blur_r, params.blur_t, params.blur_o, params.blur_method);

fea_sum = sum(fea,2);

