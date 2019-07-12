% Quick visualization of a list of points
% Georgios Georgakis 2016

function f = vis(img, list, markersize)%, params)

%sc_width = params.bin_r(length(params.bin_r)) * 2;
%code_box = [list(1,1)-sc_width/2 list(1,2)-sc_width/2 sc_width sc_width];

f=figure; imagesc(img); axis off; colormap gray; hold on;
plot(list(:,1), list(:,2), 'rx', 'MarkerSize', markersize);
%rectangle('position', code_box, 'EdgeColor', 'g', 'linewidth', 3);
hold off;
