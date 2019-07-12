
% associate each hypothesis to each object proposal and prune them accordingly
% Georgios Georgakis 2016

function [obj_result, seg_index] = assoc_hypos_to_proposals(obj_result, segments, params)

hypo_bbox = obj_result.hypo_bbox;
seg_index=[]; %seg_overlap=[]; 
for i=1:size(hypo_bbox,1)
    hbb = hypo_bbox(i,:);
    iou=[];
    for s=1:size(segments,2)
        sbb = segments{s}.bb;
        iou(s) = computeIOU(hbb,sbb,'iou');
        %keyboard
    end
    [v,ind]=max(iou);
    seg_index(i) = ind;
    %seg_overlap(i) = v;
    %keyboard
    % weight or prune hypos according to the given flags
    if params.weight_hypo, obj_result.score_list(i) = obj_result.score_list(i) * v; end
    if params.prune_hypo && v<params.over_seg_thresh, obj_result.score_list(i) = 0; end
    
end

% keep valid hypos
valid_list = find(obj_result.score_list > 0);
%seg_overlap=seg_overlap(valid_list);
if ~isempty(valid_list), obj_result = keep_valid(obj_result, valid_list); seg_index=seg_index(valid_list); end;

