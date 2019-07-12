
% associate object proposals to hypotheses. If two object proposals have an
% IoU larger than 0.5 for the same hypothesis, then merge them (rare case).

% Georgios Georgakis 2016

function segments3 = hypo_to_segment_assoc(segments, vhypos, nClasses)

hypo_index = get_assoc(segments, vhypos);

% If two object proposals are associated with the same hypothesis, then it
% means that both have IOU>0.5 with the hypothesis. Merge them.
toMerge=[];
for s=1:size(segments,2)
    id=find(s==hypo_index);
    if length(id)>1, toMerge = [toMerge ; [id(1) id(2)]]; end;
end

% merge the segments 
toIgnore=[];
for i=1:size(toMerge,1)
    ind=toMerge(i,:);    
    % to merge two segments, need to get the mean of the two centroids (in 3D and 2D)
    % need to concatenate the points (2D and 3D) and the normals
    % need to add the masks together, and calculate a new BB
    new_seg{i}.centroid_3D = (segments{ind(1)}.centroid_3D + segments{ind(2)}.centroid_3D)./2;
    new_seg{i}.centroid_2D = (segments{ind(1)}.centroid_2D + segments{ind(2)}.centroid_2D)./2;
    new_seg{i}.points_3D = [segments{ind(1)}.points_3D ; segments{ind(2)}.points_3D];
    new_seg{i}.points_2D = [segments{ind(1)}.points_2D segments{ind(2)}.points_2D];
    new_seg{i}.normals = [segments{ind(1)}.normals ; segments{ind(2)}.normals];
    new_seg{i}.mask = segments{ind(1)}.mask + segments{ind(2)}.mask;   
    % get new BB (left top right bottom)
    bb1=segments{ind(1)}.bb; bb2=segments{ind(2)}.bb;
    left = min(bb1(1),bb2(1)); top = min(bb1(2),bb2(2));
    right = max(bb1(3),bb2(3)); bottom = max(bb1(4),bb2(4));
    new_seg{i}.bb = [left top right bottom];
    
    toIgnore = [toIgnore ind(1) ind(2)];    
end

% reassign the segments by ignoring the merged ones
% add the new ones at the end
if isempty(toMerge)
    segments2=segments;
else
    count=0;
    for s=1:size(segments,2)
        if ~isempty(find(s==toIgnore)), continue; end;
        count=count+1;
        segments2{count} = segments{s};   
    end
    for i=1:size(new_seg,2)
        count=count+1;
        segments2{count} = new_seg{i};
    end
end

% need to find the association again if any merging occured
if ~isempty(toMerge)
    hypo_index = get_assoc(segments2, vhypos);
end

% include in segments2 struct, the info from its corresponding vhypo
% the bb that is kept is the one from the object proposal
scores=[];
for s=1:size(segments2,2)
    hind = hypo_index(s);
    if hind~=0
        segments2{s}.prediction = vhypos{hind}.prediction;
        segments2{s}.score = vhypos{hind}.score;
        if isfield(vhypos{hind},'probs'), segments2{s}.probs = vhypos{hind}.probs; end;
    else % if after merging, a segments has no sufficient overlap with a hypo, label it background 
        segments2{s}.prediction = nClasses;
        segments2{s}.score = 0;
        segments2{s}.probs = zeros(nClasses,1);
    end
    scores(s)=segments2{s}.score;
end

% sort the segments based on their score;
[v,ind] = sort(scores, 'ascend');
for s=1:size(segments2,2)
    segments3{s} = segments2{ind(s)};
end





