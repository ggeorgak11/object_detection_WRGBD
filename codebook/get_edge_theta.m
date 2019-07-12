% The edge map is the summation of the canny edges on depth, the pb edge
% detector on intensities and the pb on depth
% The theta map is contains the theta values (from pb depth) that
% correspond to the edge pixels along with theta values from pb rgb which
% are used to bridge discontinuities in the theta map

% Georgios Georgakis 2016

function [fedge, comb_theta] = get_edge_theta(img, depth)

[obj_edge,obj_theta] = compute_edge_pb(depth);        
[img_edge,img_theta] = compute_edge_pb(img);        

c_edge = edge(depth, 'canny', 0.08);

fedge = img_edge + obj_edge + c_edge;        
ids=find(fedge<=0.5); % threshold edge map
fedge(ids)=0;
obj_theta(ids)=0; % suppress the theta values that do not correspond to edge pixels in the edge map

comb_theta = obj_theta;
for i=1:size(comb_theta,1)
    for j=1:size(comb_theta,2)
        if obj_theta(i,j)==0 && fedge(i,j)>0
            comb_theta(i,j) = img_theta(i,j);
            %plot(j,i,'r.', 'MarkerSize', 2); 
        end
    end
end
