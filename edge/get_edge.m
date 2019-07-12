
% Compute the edge map
% Georgios Georgakis 2016

function [fedge, comb_theta] = get_edge(img, depth, dataroot, scene, frame_ind)

if ~exist([dataroot, 'edge'], 'dir'), mkdir([dataroot, 'edge']); end

edge_file = fullfile(dataroot, ['edge/', scene, '_', frame_ind,'.mat']);
edge_depth_file = fullfile(dataroot, ['edge/', scene, '_depth_', frame_ind,'.mat']);

%if ~exist('edge/', 'dir'), mkdir('edge/'); end;

% do edge detection if needed
if(~exist(edge_file,'file'))
    fprintf(1,'Begin edge detection...');
    tic;
    pimg = im2double(img);
    [t_edge,t_theta] = compute_edge_pb(pimg);
    I_edge(1).edge   = t_edge;
    I_edge(1).theta  = t_theta;
    save(edge_file,'I_edge','img');
    fprintf(1,'Edge detection: %f secs\n',toc);
else
    load(edge_file);
end 

int_edge=I_edge(1).edge; int_theta=I_edge(1).theta;

if (~exist(edge_depth_file,'file'))
    [depth_edge,depth_theta] = compute_edge_pb(depth);
    save(edge_depth_file,'depth_edge','depth_theta');
else
    load(edge_depth_file);
end

% The edge map is the summation of the canny edges on depth and the pb edge
% detector on intensities
% The theta map is contains the theta values (from pb depth) that
% correspond to the edge pixels along with theta values from pb rgb which
% are used to bridge discontinuities in the theta map

c_edge = edge(depth, 'canny');
%figure; imagesc(c_edge); colormap gray; title('canny');
I_edge(1).edge = int_edge + c_edge;
I_edge(1).theta = depth_theta;       

fedge=I_edge(1).edge;
ids=find(fedge<=0.5); % threshold edge map
fedge(ids)=0;
depth_theta(ids)=0; % suppress the theta values that do not correspond to edge pixels in the edge map

comb_theta = depth_theta;
for i=1:size(comb_theta,1)
    for j=1:size(comb_theta,2)
        if depth_theta(i,j)==0 && fedge(i,j)>0
            comb_theta(i,j) = int_theta(i,j);
            %plot(j,i,'r.', 'MarkerSize', 2); 
        end
    end
end



    
