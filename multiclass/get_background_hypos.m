

function hypos = get_background_hypos(hypos, over_thresh, segments, back_lbl)

% Get tp for background using the pre-computed segments. If a segment has
% no overlap with gtBB or a prediction then its tp.
% This assumes that predictions which did not have IOU>0.5 with any segment
% where discarded during the detection process.

% Georgios Georgakis 2016

hypoBB=[];
for h=1:size(hypos,2)
    hbb = hypos{h}.bb;
    hypoBB(h,:) = [hbb(1) hbb(2) hbb(3)-hbb(1) hbb(4)-hbb(2)]; 
end
seg_cover = zeros(size(segments,2),1);
for s=1:size(segments,2)   
    segBB = segments{s}.bb;
    segBB(3)=segBB(3)-segBB(1); segBB(4)=segBB(4)-segBB(2);
    
    % proposals not covered by hypos are tp for background
    for t=1:size(hypoBB,1)
        tBB = hypoBB(t,:);
        intersect = rectint(tBB, segBB);
        tBB_area = tBB(3)*tBB(4);
        segBB_area = segBB(3)*segBB(4);
        overlap = intersect / (tBB_area + segBB_area - intersect);
        if overlap>over_thresh, seg_cover(s)=1; break; end       
    end
        
end

b=find(seg_cover==0);
l=size(hypos,2);
if ~isempty(b) % add the segments as background hypo predictions
    for i=1:length(b)
        ind = b(i); 
        hypos{l+i}.score = 0;
        hypos{l+i}.bb = segments{ind}.bb;
        hypos{l+i}.prediction = back_lbl;
        hypos{l+i}.probs = zeros(back_lbl,1);
    end
end