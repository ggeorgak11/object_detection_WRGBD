% Georgios Georgakis 2016

function pos = sample_location_in_mask_on_edges(mask, pb_edge, params)

objmask = find(mask); %get indices of the object mask
objmask_ind = [mod(objmask(:), size(mask,1)) floor(objmask(:)/size(mask,1)) + 1]; 

pos = []; step=0;
for i=1:size(objmask_ind)
    x = objmask_ind(i,1);
    y = objmask_ind(i,2);
    if (pb_edge(x,y) > params.edge_thresh)
        step = step + 1;
        if (step==params.step_length)
            pos = [pos; [y x]];
            %plot(y, x, 'r+', 'MarkerSize', 3);
            step=0;
        end
    end
    
end