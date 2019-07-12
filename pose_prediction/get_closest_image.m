
% Get the training image with the most similar pose with the hypothesis
% Georgios Georgakis 2016

function closest_img_id = get_closest_image(current_pose_id, codebook, codes_ids, figs_visible)
list = codebook.annolist;
% get the codebook entries that voted for the most voted pose
num=0; predicted_code_ids=[];
for c=1:length(codes_ids)
    cid = codes_ids(c);
    if codebook.pose_id(cid) == current_pose_id
        num = num + 1;
        predicted_code_ids(num) = codes_ids(c); % codebook entries that voted for the most voted pose
    end
end

predicted_img_ids = codebook.img_id(predicted_code_ids); % training images where the votes came from

% get the image which most votes came from
h=hist(predicted_img_ids, 1:length(list));
[o, closest_img_id] = max(h);


% to show the closest images uncomment below

%closest_img = list(closest_img_id).I;
%azimuth = list(closest_img_id).azimuth;
%elevation = list(closest_img_id).elevation;

%figure; if ~figs_visible, set(gcf,'Visible', 'off'); end
%imagesc(closest_img); 
%title(['Pose id:', num2str(current_pose_id), ' Azimuth:', num2str(azimuth), ' Elevation:', num2str(elevation)]);

