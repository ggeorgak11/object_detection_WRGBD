
% Get confusion matrix after multiview is done.
% Georgios Georgakis 2016

function [scene_conf, scene_res] = evaluate_scene(bboxes, frame, params, objstr_list, segments)

lc = length(objstr_list);
scene_conf = zeros(lc+1,lc+1);
scene_res = zeros(lc,4);
fr_count=1;
for fr=1:5:size(bboxes,2)
    frame_ind = num2str(fr);

    test_info = bboxes{str2double(frame_ind)}; %get info of test image
    gtBB = get_gtBBoxes(test_info, 0, '', '');

    hypos=frame{fr_count}.hypos;  fr_count=fr_count+1;

    % Rows are the predicted labels and columns are the ground truth
    [confusion, ~] = getConfusionMatrix(hypos, test_info, gtBB, objstr_list, segments, params.over_thresh);

    res = zeros(length(objstr_list),4); % tp fp tn fn
    for i=1:length(objstr_list)
        res(i,1) = confusion(i,i); % tp
        res(i,2) = sum(confusion(i,:)) - confusion(i,i); % fp
        res(i,3) = sum(diag(confusion)) - confusion(i,i); % tn
        res(i,4) = sum(confusion(:,i)) - confusion(i,i); % fn
    end

    % get scene confusion matrix and res over all frames
    scene_res = res + scene_res;
    scene_conf(2:lc+1,2:lc+1) = scene_conf(2:lc+1,2:lc+1) + confusion;
end 
        