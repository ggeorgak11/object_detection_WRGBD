


function [std_z, m_Z, pixel_ar, pixel_h] = depth_statistics(mask, depth)

% Georgios Georgakis 2016

objmask = find(mask); %get indices of the object mask
objmask_ind = [mod(objmask(:), size(mask,1)) floor(objmask(:)/size(mask,1)) + 1];   

%get the dimensions on the image
up = min(objmask_ind(:,1));
down = max(objmask_ind(:,1));
left = min(objmask_ind(:,2));
right = max(objmask_ind(:,2));
pixel_h = down-up; pixel_w = right-left;
pixel_ar = pixel_h / pixel_w;

%get median depth value and standard deviation of mask
d = zeros(size(objmask_ind,1),1);
for i=1:size(objmask_ind,1)
    d(i) = depth(objmask_ind(i,1), objmask_ind(i,2));
end

std_z = std(d);
m_Z = median(d);
