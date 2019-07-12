

function [vhypos, segments] = multiclass_detection(params, img, depth, edge_map, theta_map, objstr_list, cb_path)

% Perform multiclass detection a single given frame
% Georgios Georgakis 2016

% find the large and support surfaces
[supp_surf, surface_eq, large_planes, plane_labels, plane_eq] = get_support_surface(img, depth, params);
if params.verbose, disp('--- Support surfaces...done'); end
% cluster the 3d point cloud to get the segments
segments = form_segments(img, depth, large_planes, surface_eq, supp_surf, plane_labels, plane_eq, params);
if params.verbose, disp('--- Proposal estimation...done'); end

hypo_count=1; hypos_frame={};
for ob=1:length(objstr_list)-1 % assuming last class is background
    objstr = objstr_list{ob};
    if params.verbose, disp(['--- Running detector for ', objstr]); end
    
    params.bin_r = define_bin_r(objstr); % redefine the size of the sc given the object
    % load the codebook for current object
    load([cb_path, 'cb_', objstr, '.mat']); % loads codebook of objstr
    % run the class specific object detector  
    obj_result = class_specific_detector(img, edge_map, theta_map, depth, codebook, large_planes, params, segments, objstr);
    if isempty(obj_result), continue; end;
    %visualize_hypos(obj_result, img, params.figs_visible, objstr);
    
    [obj_result, ~] = assoc_hypos_to_proposals(obj_result, segments, params);
    
    % get the hypos of this frame over all object classes
    hypo_score = obj_result.score_list;          
    for i=1:size(hypo_score,1)                
        if hypo_score(i) < params.score_thresh, continue; end; % prune hypos before any normalization

        % use the mean and std calculated for each object to compute its normalized score
        score1=(hypo_score(i) - params.obj_norm_params{ob}.mean) / params.obj_norm_params{ob}.std;
        if score1 < params.norm_score_thresh, continue; end; % threshold

        hypos_frame{hypo_count}.score = score1;
        %hypos_frame{hypo_count}.bb = segments{seg_index(i)}.bb;
        hypos_frame{hypo_count}.bb = obj_result.hypo_bbox(i,:);
        hypos_frame{hypo_count}.prediction = ob;
        hypos_frame{hypo_count}.probs = zeros(length(objstr_list),1);
        hypos_frame{hypo_count}.probs(ob) = score1;
        hypo_count = hypo_count+1;                
    end
end

vhypos={};
% if there are no hypos in the frame then don't do nms
if isempty(hypos_frame)
    vhypos = hypos_frame;
else     
    % perform nms, create a score distribution based on the association of
    % the hypos to the segments
    [valid_hypos, hypos_frame] = nms(hypos_frame, params.nms_mode, params.over_thresh);
    for i=1:length(valid_hypos)
        v = valid_hypos(i);
        vhypos{i} = hypos_frame{v};
    end
end

% segments not assigned to a hypothesis are perceived as background
vhypos = get_background_hypos(vhypos, params.over_thresh, segments, length(objstr_list));

if params.verbose, disp('Multiclass prediction...done'); end
%visualize_frame(vhypos, img, objstr_list, params.figs_visible, '');


