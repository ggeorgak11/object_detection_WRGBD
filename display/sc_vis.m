
% During testing, pick a testpos on the image to see the SC and its
% codebook matches

% Georgios Georgakis 2016

function sc_vis(pb_edge, pb_theta, para_sc, testpos, scoresK_id, codebook, scoresK)
codes = codebook.codes;

[~, mask_vis] = compute_bin_mask(para_sc.bin_r, para_sc.nb_bin_theta);
%nb_ori = para_sc.nb_ori;


while(1)
    figure; imagesc(pb_edge); colormap gray; hold on;
    plot(testpos(:,1), testpos(:,2), 'r.', 'MarkerSize', 5);
    hold off;
    
    [px,py] = ginput(1);
    px = round(px);
    py = round(py);
    
    if (px==1 && py==1)
        break;
    end
    
    %plot(px, py, 'g+', 'MarkerSize', 10);
    location = [px py];
    %keyboard
    %find here if the location is actually a testpos, find its index,
    %and the matched codebook entries and visualize
    flag=0;
    for i=1:size(testpos,1)
        if (px == testpos(i,1) && py == testpos(i,2))
            ind = i;
            flag = 1;
            break;
        end
    end
    if flag==0
        continue;
    end
      
    sc_width = para_sc.bin_r(length(para_sc.bin_r)) * 2;
    sc_box = [px-sc_width/2 py-sc_width/2 sc_width sc_width];
    figure; imagesc(pb_edge); colormap gray; title('sample point'); hold on;
    rectangle('position', sc_box, 'EdgeColor', 'g', 'linewidth', 2);
    plot(px, py, 'r.', 'MarkerSize', 5); hold off;
    
    %extract the testpoint feature and plot it
    [fea,fea_sum]   = extract_sc_feature(pb_edge, pb_theta, location, para_sc); 
    norm_fea = spmtimesd(sparse(fea),1./fea_sum,[]);
    norm_fea = full(norm_fea);
    plot_feature(norm_fea, para_sc, mask_vis, 'Sample point feature');
    
    %find its matched codebook entries
    for i=1:1
        code_ind  = scoresK_id(ind,i); % codebook entry index
        
        % show the exact position where the SC was extracted from
        loc = codebook.location(code_ind,:);
        tr_img_id = codebook.img_id(code_ind);
        tr_img = codebook.annolist(tr_img_id).edge;      
        figure; imagesc(tr_img); colormap gray; hold on;
        code_box = [loc(1)-sc_width/2 loc(2)-sc_width/2 sc_width sc_width];
        rectangle('position', code_box, 'EdgeColor', 'g', 'linewidth', 5);
        plot(loc(1), loc(2), 'r.', 'MarkerSize', 2); hold off;
        
        % show the shape context feature of the codebook entry
        match_score = scoresK(ind,i);
        code_fea = codes(code_ind,:);
        plot_feature(code_fea, para_sc, mask_vis, [num2str(i), '  ', num2str(match_score)]);
        
        % replicate how the score is computed
        code_weight = codebook.sc_weight(code_ind,:); % weight of the code from codebook 
        fea = fea.*code_weight; % weight the test feature 
        fea	= spmtimesd(sparse(fea),1./fea_sum,[]); % normalize the test feature
        fea = full(fea);
        chi2_dist = 1 - (sum((fea-code_fea).^2 / (fea+code_fea+eps)) / 2)
    end
    
    %pause;
    keyboard
    close all;
    
end





