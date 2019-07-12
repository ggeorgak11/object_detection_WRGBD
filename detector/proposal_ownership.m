

function [candidate_pos_valid new_valid_idx] = proposal_ownership(segments, img, testpos, candidate_pos, valid_idx, params, depth)

% Pruning of votes based on equation 1 from the paper.
% If a vote starts from a certain segment and ends not to the same segment
% then it is considered invalid

% Georgios Georgakis 2016


%get the valid votes thus far
nb_test = size(testpos,1);
testpos_idx = mod(valid_idx-1, nb_test) + 1;
testpos = testpos(testpos_idx,:);

% dilate all the masks from before so that you wont have to do it each iteration
% fix: instead of dilating each mask independently, dilate all of them
% together, and then find the new areas and add them to each segment's mask
global_area = zeros(size(img,1),size(img,2));
for s=1:size(segments,2)
    global_area = global_area + segments{s}.mask; 
    seg_masks(:,:,s) = segments{s}.mask;
    seg_masks2(:,:,s) = segments{s}.mask; % to be used later
end
se = strel('disk',5);
global_dilated = imdilate(global_area,se);

extra = global_dilated - global_area;
[r,c]=find(extra);

for p=1:length(r)
    % point (r(i),c(i)) belongs to the mask that is in front (lower median depth)
    % first sample the area around the point to find which masks are there    
    sample = sample_area([r(p) c(p)], global_area, 3);
    mask_ids = zeros(size(sample,1),1);
    for i=1:size(sample,1)
        a=find(seg_masks2(sample(i,1),sample(i,2),:));
        if ~isempty(a), mask_ids(i)=a; end;
    end    
    mask_ids = mask_ids(mask_ids~=0);
    if isempty(mask_ids), continue; end; % if no masks were found, then do not assign the point to any mask
    mids = unique(mask_ids);

    if length(mids)==1, seg_masks(r(p), c(p), mids) = 1; continue; end %in this case add the point to the current mask directly
    
    % get the median depth of the masks in mids
    mdepth=[];
    for i=1:length(mids)
        mask = segments{mids(i)}.mask;
        ind = find(mask);
        mdepth(i) = median(depth(ind));
    end

    [v,index]=min(mdepth);
    sind=mids(index); % the segment that the point should be added
    seg_masks(r(p), c(p),sind) = 1;
end

ind=0; testpos2=[]; candidate_pos_valid=[]; new_valid_idx=[];
for i=1:size(testpos,1)
    % get the segment(s) this testpos is in
    test_pos_seg = find(seg_masks(testpos(i,2),testpos(i,1),:));
    if length(test_pos_seg) > 1, test_pos_seg=test_pos_seg(1); end;
    
    % get the segment that its vote resides
    candidate_pos = bring_in_bounds(candidate_pos, i, size(img));
    vote_pos_seg = find(seg_masks(candidate_pos(i,2),candidate_pos(i,1),:));
    if length(vote_pos_seg) > 1, vote_pos_seg=vote_pos_seg(1); end;
    
    if test_pos_seg == vote_pos_seg
    %if same
        ind = ind+1;
        new_valid_idx(ind) = valid_idx(i,1);
        candidate_pos_valid(ind,1) = candidate_pos(i,1);
        candidate_pos_valid(ind,2) = candidate_pos(i,2);
        %just for visualizing the lines
        testpos2(ind,1) = testpos(i,1);
        testpos2(ind,2) = testpos(i,2);
    end 
end


figure; if ~params.figs_visible, set(gcf,'Visible', 'off'); end
imagesc(img); axis off; colormap gray; hold on; title('After pruning votes');
for i=1:size(testpos2,1)
    line([testpos2(i,1) candidate_pos_valid(i,1)], [testpos2(i,2) candidate_pos_valid(i,2)], 'Color', 'y', 'LineWidth', 0.2);
end
plot(testpos(:,1), testpos(:,2), 'r.', 'MarkerSize', 10);
if ~isempty(candidate_pos_valid), plot(candidate_pos_valid(:,1), candidate_pos_valid(:,2), 'g+', 'MarkerSize', 6); end;
hold off;

