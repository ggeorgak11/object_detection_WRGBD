

function f = visualize_frame(hypos, img, classes, visible, ttle)
    
% visualize multiclass predictions for a certain frame
% Georgios Georgakis 2016

f=figure; if ~visible, set(gcf,'Visible', 'off'); end; 
imagesc(img); title(ttle); axis off; hold on; 
for i=1:size(hypos,2)
    bb = hypos{i}.bb; 
    vis_bb = [bb(1) bb(2) bb(3)-bb(1) bb(4)-bb(2)];
    if hypos{i}.prediction==length(classes), 
        color='y';
    else
        color='g'; 
    end;
    
    objPred = classes{hypos{i}.prediction};
    %score = hypos{i}.score;
    
    objPred = strrep(objPred, '_', ' ');
    rectangle('position', vis_bb, 'EdgeColor', color, 'linewidth', 2);
    rectangle('position', [bb(1) bb(2)-13 bb(3)-bb(1) 13], 'EdgeColor', color, 'FaceColor', color, 'linewidth', 2);
    %text(bb(1)+5, bb(2)-8, [objPred, '  ', num2str(score)], 'Color', 'k', 'FontSize', 35);
    text(bb(1)+2, bb(2)-8, objPred, 'Color', 'k', 'FontSize', 35, 'FontWeight', 'Bold');
    %set(t, 'FontWeight', 'Bold');
end
hold off;    