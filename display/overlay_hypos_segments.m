
% Visualization where the hypotheses are overlaid with the proposals

function f = overlay_hypos_segments(recog_result, segments, img)

% INPUT: recog_result (output of class_specific_detector)
%        segments (proposals)
%        img
%OUTPUT: f (figure handler)

% Georgios Georgakis 2016

bbs=recog_result.hypo_bbox;
scores=recog_result.score_list;
color='g';

linewidth=2;

f=figure; %if ~visible, set(gcf,'Visible', 'off'); end; 
imagesc(img); axis off; hold on;

seg_bb = zeros(size(segments,2),4);
for i=1:size(segments,2)
    x=segments{i}.points_2D(1,:);
    y=segments{i}.points_2D(2,:);
    bb(i,:) = [min(x) min(y) max(x) max(y)];
    seg_bb(i,:) = [bb(i,1) bb(i,2) bb(i,3)-bb(i,1) bb(i,4)-bb(i,2)];
    rectangle('position', seg_bb(i,:), 'EdgeColor', 'm', 'linewidth', linewidth);
end

for i=1:size(bbs,1)
    bb = bbs(i,:); score = scores(i);
    vis_bb = [bb(1) bb(2) bb(3)-bb(1) bb(4)-bb(2)];
    rectangle('position', vis_bb, 'EdgeColor', color, 'linewidth', 2);
    rectangle('position', [bb(1) bb(2)-13 bb(3)-bb(1) 13], 'EdgeColor', color, 'FaceColor', color, 'linewidth', linewidth);
    %text(bb(1)+5, bb(2)-8, [objPred, '  ', num2str(score)], 'Color', 'k', 'FontSize', 35);
    text(bb(1)+5, bb(2)-8, num2str(score), 'Color', 'k', 'FontSize', 35);
end
hold off;

