function pos = sample_test_location_on_edges(edge_map, depth, sample_step, edge_thresh)

% Georgios Georgakis 2016

pos = []; step = 0;
%for i=1:size(edge_map,1)
%    for j=1:size(edge_map,2)
for i=1:size(edge_map,1)  % change the boundaries to avoid the empty depth space
    for j=1:size(edge_map,2)
        % edge map is already thesholded
        if (edge_map(i,j) > edge_thresh) % 0.18, && depth(i,j) <= depth_thresh
            step = step + 1;
            if (step==sample_step) % 60
                pos = [pos; [j i]];
 %               plot(j, i, 'r+', 'MarkerSize', 3);
                step=0;
            end
        end
        
    end
end