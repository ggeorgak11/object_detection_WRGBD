
function codebook = load_codebook_with_viewpoints(viewpoints, params)

% use the viewpoint discretized data to create a codebook where the codes
% have pose ids 

% Georgios Georgakis 2016


% compute the Shape Context bins' masks
[sc_mask, ~] = compute_bin_mask(params.bin_r, params.nb_bin_theta);

codebook    = [];
annolist    = [];

numOfViews=size(viewpoints,2);
img_index = 0;
for v=1:numOfViews
    current_viewpoint = viewpoints(v).info;
    v
    for im=1:params.sampling_step:size(current_viewpoint,2)
        img = current_viewpoint(im).img;
        mask = current_viewpoint(im).mask;
        depth = current_viewpoint(im).depth;
        loc = current_viewpoint(im).loc;
        azimuth = current_viewpoint(im).azimuth;
        elevation = current_viewpoint(im).elevation;
        pose_id = current_viewpoint(im).pose_id;
        
        % find std and median depth from each object mask
        [std_z, m_Z, pixel_ar, pixel_h] = depth_statistics(mask, depth);
                
        %%%%%% PB boundary detector
        [edge_map, theta_map] = get_edge_theta(img, depth);
        % dilate the mask so as not to lose edges
        % filter the edge,theta map with the mask
        mask = imdilate(mask,params.se);
        edge_map = edge_map.*mask;
        theta_map = theta_map.*mask;
        %%%%%%
                
        % keep all relevant info about the training image
        img_index = img_index + 1;
        annolist(img_index).I = img;
        annolist(img_index).edge =edge_map;
        annolist(img_index).theta=theta_map;
        annolist(img_index).mask=mask;
        annolist(img_index).depth=depth;
        annolist(img_index).img_name = current_viewpoint(im).name;
        annolist(img_index).loc = loc;
        annolist(img_index).median_Z = m_Z;
        annolist(img_index).pixel_ar = pixel_ar;
        annolist(img_index).pixel_h = pixel_h;
        annolist(img_index).std_z = std_z;
        annolist(img_index).azimuth = azimuth;
        annolist(img_index).elevation = elevation;
        annolist(img_index).pose_id = pose_id;
        
        % create the codebook entries for this training image
        codebook1 = proc_oneimage_codes(edge_map, theta_map, mask, sc_mask, params);
        if(isempty(codebook1)), continue; end
        
        code_len = size(codebook1.location,1);
        codebook1.img_id=ones(code_len,1)*img_index;
        codebook1.pose_id=ones(code_len,1)*pose_id;
        
        % insert current codebook1 to codebook
        codebook = insert_codebook(codebook, codebook1); 
    end
end

if(isempty(codebook))
    error('no training data found');
end

codebook.relpos = round(codebook.relpos);
codebook.para = params;
codebook.annolist = annolist;

