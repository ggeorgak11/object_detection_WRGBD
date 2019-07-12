% plot the Shape context descriptor

% Georgios Georgakis 2016

function plot_feature(fea, params, mask_vis, plot_title)
nb_ori = params.nb_ori;
%reshape the feature to distinguish the orientations
fea = reshape(fea, [size(fea,1) size(fea,2)/nb_ori nb_ori]);

%keyboard

c_zero=0;
for i=1:size(fea,3)
    or = fea(1,:,i);
    if all(or==0)
        c_zero = c_zero + 1;
    end
end  
non_zero = size(fea,3) - c_zero;

%visualize the descriptor using the mask_vis and fea.
pos = 0;
figure; 
for ori=1:size(fea,3)
%for ori=1:1
    ori_feat = fea(1,:,ori);
    if all(ori_feat==0)
        continue;
    end
    ori_vis = zeros(size(mask_vis,1), size(mask_vis,2));

    for i=1:length(ori_feat)
        for m1=1:size(mask_vis,1)
            for m2=1:size(mask_vis,2)
                %assign the value to the corresponding bin
                if (mask_vis(m1,m2)==i)
                    ori_vis(m1,m2) = ori_feat(i);
                end

            end
        end
    end

    pos = pos + 1;
    subplot(1, non_zero, pos);
    %figure; 
    imagesc(ori_vis); colormap gray;
    axis image
    title(plot_title);

end

figure; pos=0;
for ori=1:size(fea,3)
    hist1 = fea(:,:,ori);
    hist11 = reshape(hist1, [length(params.bin_r)-1 params.nb_bin_theta]);
        
    pos = pos+1;
    subplot(1, non_zero, pos);
    imagesc(hist11); colormap gray;
    axis image
    title(plot_title);
end



