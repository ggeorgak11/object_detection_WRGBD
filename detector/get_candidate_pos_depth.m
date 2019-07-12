function [candidate_pos_new, new_relpos] = get_candidate_pos_depth(valid_idx,...
    scoresK_id, codebook, testpos, depth, params, img)

% Find the voting positions for the center of the objects, taking into consideration
% the scaling of the vote based on the depth ratio

% Georgios Georgakis 2016

nb_test = size(testpos,1);
testpos_idx = mod(valid_idx-1, nb_test) + 1;
scoresK_id = scoresK_id(valid_idx);
testpos = testpos(testpos_idx,:);
relpos = codebook.relpos(scoresK_id,:);

% Iterate scoresK_id to get each code_index
% get Image_id --> get median_Z
% get corresponding test_pos --> also its depth
% find the depth ratio --> resize the corresponding relpos
for i=1:length(scoresK_id)
    code_index = scoresK_id(i);
    img_id = codebook.img_id(code_index);
    median_Z = codebook.annolist(img_id).median_Z;
    % sample around the testpos for the median depth
    test_Z = sample_depth(depth, testpos(i,:));
    if test_Z==0, Z_ratio=1;
    else Z_ratio = median_Z / test_Z;
    end  
    new_relpos(i,:) = round(relpos(i,:) * Z_ratio);
end

candidate_pos = testpos+relpos;
candidate_pos_new   = testpos+new_relpos;

% Plot the new candidate points and the previous  

figure; if ~params.figs_visible, set(gcf,'Visible', 'off'); end
imagesc(img); axis off; colormap gray; hold on;
%set(gca,'LooseInset',get(gca,'TightInset'));
for i=1:size(testpos,1)
    %if scoresK(i) < 0, c='r'; else, c='y'; end
    line([testpos(i,1) candidate_pos(i,1)], [testpos(i,2) candidate_pos(i,2)], 'Color', 'y', 'LineWidth', 0.2);
end
plot(testpos(:,1), testpos(:,2), 'r.', 'MarkerSize', 10);
plot(candidate_pos(:,1), candidate_pos(:,2), 'g+', 'MarkerSize', 6);
hold off;

figure; if ~params.figs_visible, set(gcf,'Visible', 'off'); end
imagesc(img); axis off; % colormap gray; 
hold on; title('After resizing relpos');
%set(gca,'LooseInset',get(gca,'TightInset'));
for i=1:size(testpos,1)
    line([testpos(i,1) candidate_pos_new(i,1)], [testpos(i,2) candidate_pos_new(i,2)], 'Color', 'y', 'LineWidth', 0.2);
end
plot(testpos(:,1), testpos(:,2), 'r.', 'MarkerSize', 10);
plot(candidate_pos_new(:,1), candidate_pos_new(:,2), 'g+', 'MarkerSize', 6);
hold off;

