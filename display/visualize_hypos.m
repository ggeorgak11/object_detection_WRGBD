
% visualize just the hypotheses of a certain object detector
% Georgios Georgakis 2016

function f = visualize_hypos(recog_result, img, visible, obj)
    
bbs=recog_result.hypo_bbox;
scores=recog_result.score_list;
color='g';

f=figure; if ~visible, set(gcf,'Visible', 'off'); end; 
imagesc(img); axis off; hold on; title(obj);
for i=1:size(bbs,1)
    bb = bbs(i,:); score = scores(i);
    vis_bb = [bb(1) bb(2) bb(3)-bb(1) bb(4)-bb(2)];
    rectangle('position', vis_bb, 'EdgeColor', color, 'linewidth', 2);
    rectangle('position', [bb(1) bb(2)-13 bb(3)-bb(1) 13], 'EdgeColor', color, 'FaceColor', color, 'linewidth', 2);
    %text(bb(1)+5, bb(2)-8, [objPred, '  ', num2str(score)], 'Color', 'k', 'FontSize', 35);
    text(bb(1)+5, bb(2)-8, num2str(score), 'Color', 'k', 'FontSize', 35);
end
hold off;