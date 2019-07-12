
% Get the bounding boxes of the segments

% Georgios Georgakis 2016

function [recog_result, found_hypo_flag] = getSegmentsBB(img, segments)

if size(segments,2)==0
    recog_result.hypo_list = [];
    recog_result.hypo_bbox = [];
    recog_result.score_list = [];
    found_hypo_flag=0;
else
    %figure; imagesc(img); hold on;
    for i=1:size(segments,2)
        cent_list(i,:) = segments{i}.centroid_image;
        score_list(i) = 1;
        x=segments{i}.points_image(1,:);
        y=segments{i}.points_image(2,:);

        bb(i,:) = [ min(x) min(y) max(x) max(y)];
        vis_bb = [bb(i,1) bb(i,2) bb(i,3)-bb(i,1) bb(i,4)-bb(i,2)];
        %rectangle('position', vis_bb, 'EdgeColor', 'g', 'linewidth', 2);

    end

    recog_result.hypo_list = cent_list;
    recog_result.hypo_bbox = bb;
    recog_result.score_list = score_list;
    found_hypo_flag=1;
end

%keyboard