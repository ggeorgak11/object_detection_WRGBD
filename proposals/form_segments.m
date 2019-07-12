
% Generate the segments of the object proposals using Mean-shift
% INPUT: large_planes, surface_eq, supp_surf, plane_labels, plane_eq (output of get_support_surface())
%        img
%        depth (depth image)
%        params
% OUTPUT: segments (struct holding the proposals information)

% Georgios Georgakis 2016

function segments = form_segments(img, depth, large_planes, surface_eq, supp_surf, plane_labels, plane_eq, params)

[pcloud, ~] = depthToCloud(depth, params.focal_length, params.center);

X=pcloud(:,:,1);
Y=pcloud(:,:,2);
Z=pcloud(:,:,3);
aa=find(~isnan(Z)); % remove any NaN values from pcloud
X=X(aa); Y=Y(aa); Z=Z(aa);

large_planes = large_planes(aa); % keep the large planes values that do not correspond to nan on depth
p = find(large_planes==0);
X=X(p); Y=Y(p); Z=Z(p);
pcl = [X Y Z];
% subsample from the pcl
l=size(pcl,1);
pcl = pcl(1:params.pcl_subsample:l, :); 

% use the median depth value of the support surface to find a value for the
% range parameter of the mean_shift
z=median(depth(find(supp_surf(:,:,1)>0))); % find the median depth value of the support surface
r = (z-params.min_z)/(params.max_z-params.min_z); % normalize 0...1
range = (r*(params.max_range-params.min_range))+params.min_range; % normalize min_range...max_range
if range<params.min_range, range=params.min_range; elseif range>params.max_range, range=params.max_range; end % bound it

[C,A,clusters] = MeanShiftCluster(pcl',range); % def range = 0.1

% if a cluster contains several connected components on the image plane,
% then divide them in different clusters, and if they are too small they
% are going to be rejected later anyway. Recalculate the centroid of the
% cluster.
v=0;
for i=1:size(C,2)
    curr_cluster = clusters{i};
    points_3D = pcl(curr_cluster,:);
    
    x1=[]; y1=[];
    for j=1:size(points_3D,1)
        x1(j)=round((points_3D(j,1)*params.focal_length)/points_3D(j,3) + params.center(1));
        y1(j)=round((points_3D(j,2)*params.focal_length)/points_3D(j,3) + params.center(2));
    end
    % create a 2D mask for each segment
    mask = zeros(size(depth,1), size(depth,2));
    for w=1:length(x1)
       mask(y1(w), x1(w)) = 1;
    end   
    cc = bwconncomp(mask);
    
    % iterate through the components of the cluster and decide for each if it's a valid segment
    for k=1:size(cc.PixelIdxList,2)
        comp_size = length(cc.PixelIdxList{k});
        % prune out small components
        if comp_size < params.min_cluster_size, continue; end;
        ids=cc.PixelIdxList{k};       
        comp_mask = zeros(size(depth,1), size(depth,2));
        comp_mask(ids)=1;
        %figure; imagesc(comp_mask);
               
        % find which 2D coordinates comprise the new segment
        q=0; kept=[];
        for p=1:length(x1);
            if comp_mask(y1(p),x1(p))==1
               q=q+1;
               kept(q)=p;
            end
        end
        points_3D_comp = points_3D(kept,:); 
        
        % recompute the cluster centroid
        xx=points_3D_comp(:,1); l=length(xx);
        yy=points_3D_comp(:,2);
        zz=points_3D_comp(:,3);
        comp_3D_centroid = [ sum(xx)/l ; sum(yy)/l ; sum(zz)/l ];
        
        % iterate through the support surfaces and estimate the distance of
        % the current component centroid from them. Keep the component that
        % is close enough to any one of the surfaces
        isValid=0;
        for s=1:size(surface_eq,1)    
            n = surface_eq(s,1:3); d = surface_eq(s,4);
            p = d / sqrt(n(1)^2 + n(2)^2 + n(3)^2);
            dist_from_surface=abs(dot(n,comp_3D_centroid) + p);
            %info = [i centroids_x(i) centroids_y(i) s dist_from_surface]
            if dist_from_surface < params.max_dist_from_support
                isValid=1; break;
            end   
        end
        % if its valid, then add it to the segments list
        % a segment is comprised of 2D_centroid, 3D_centroid, 3D_points,
        % 2D_points, mask, normals
        if isValid==1
            v=v+1;
            
            % recompute the 2D_centroid from the new 3D_centroid
            comp_cent_x=round((comp_3D_centroid(1)*params.focal_length)/comp_3D_centroid(3) + params.center(1));
            comp_cent_y=round((comp_3D_centroid(2)*params.focal_length)/comp_3D_centroid(3) + params.center(2));
            
            % keep the normals labels and their equations for each segment
            lbls = plane_labels(comp_mask>0);
            lbls = unique(lbls); lbls=lbls(lbls~=0);
            normals = plane_eq(lbls,:);
            
            % do imclose in the mask in order to fill in the gaps from the
            % subsampling of the pointcloud. After this operation, the
            % points in the mask will not correspond to the points3D or points2D
            disk = strel('square',2);
            comp_mask=imclose(comp_mask,disk);
            
            segments{v}.centroid_3D = comp_3D_centroid;
            segments{v}.centroid_2D = [comp_cent_x comp_cent_y];            
            segments{v}.points_3D = points_3D_comp;
            segments{v}.points_2D = [x1(kept) ; y1(kept)];
            segments{v}.mask = comp_mask; 
            segments{v}.normals = normals;            
        end
        
    end
        
end

if ~exist('segments','var'), segments=[]; return; end;

for i=1:size(segments,2)
    x = segments{i}.points_2D(1,:);
    y = segments{i}.points_2D(2,:);
    segments{i}.bb = [min(x) min(y) max(x) max(y)]; % left top right bottom
end

% plot the valid segments on the 2D image
figure; if ~params.figs_visible, set(gcf,'Visible', 'off'); end
imagesc(img); axis off; %title(['MeanShift range: ', num2str(range)]); 
hold on;
colors = jet(size(segments,2)); cross_col = size(segments,2);
for i=1:size(segments,2)    
    x=segments{i}.points_2D(1,:); y=segments{i}.points_2D(2,:);
    plot(x, y, '.', 'MarkerSize', 4, 'MarkerEdgeColor', colors(i,:), 'MarkerFaceColor', colors(i,:));
    cross_col=cross_col-1;
end
hold off;

