
% Visualize the proposals (output of form_segments()) for a certain frame
% Georgios Georgakis 2016

function f = visualize_proposals(segments, img, visible)

f=figure; if ~visible, set(gcf,'Visible', 'off'); end
title('Object proposals');
imagesc(img); axis off; hold on;

seg_bb = zeros(size(segments,2),4);
for i=1:size(segments,2)
    x=segments{i}.points_2D(1,:);
    y=segments{i}.points_2D(2,:);
    bb(i,:) = [min(x) min(y) max(x) max(y)];
    seg_bb(i,:) = [bb(i,1) bb(i,2) bb(i,3)-bb(i,1) bb(i,4)-bb(i,2)];
    rectangle('position', seg_bb(i,:), 'EdgeColor', 'm', 'linewidth', 2);
end
hold off;
