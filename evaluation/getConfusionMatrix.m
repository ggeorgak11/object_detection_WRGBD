
% Georgios Georgakis 2016

function [confusion, hypos] = getConfusionMatrix(hypos, test_info, gtBB, classes, segments, over_thresh)

% For each frame find the confusion matrix
back_lbl = length(classes);
confusion = zeros(length(classes), length(classes));
gtBB_cover = zeros(size(gtBB,1),1);
for i=1:length(classes) % iterate the classes
    objstr = classes{i};

    for s=1:size(hypos,2) % iterate the predictions for each class
        if hypos{s}.prediction~=i, continue; end;
        bb=hypos{s}.bb; % bb prediction
        bb(3)=bb(3)-bb(1); bb(4)=bb(4)-bb(2);
        found=0;

        % iterate the gtBBs...if this is empty then the fp for the particular prediction will be recorded
        for t=1:size(gtBB,1)    
            intersect = rectint(gtBB(t,:), bb);
            gtBB_area = gtBB(t,3)*gtBB(t,4);
            bb_area = bb(3)*bb(4);
            overlap = intersect / (gtBB_area + bb_area - intersect);

            if overlap>over_thresh % if IOU>0.5
               %keyboard 
               found=1; gtBB_cover(t) = 1; % keep track of which gtBB were covered
               % find later if a gtBB had no prediction on it
               if strcmp(test_info(t).category,objstr)
                   confusion(i,i) = confusion(i,i) + 1; % tp
               else
                   % get the gt category label
                   lbl=get_obj_label(test_info(t).category);
                   confusion(i,lbl) = confusion(i,lbl) + 1; % wrong prediction
               end
               break;
            end
        end
       if ~found
        % a prediction has no overlap with ground truth object --> fp
        % gt is background
        confusion(i,back_lbl) = confusion(i,back_lbl) + 1;
       end

    end           
end
% find gtBBs that had no predictions. this also covers the case when hypos is empty
% false negatives
a=find(gtBB_cover==0);
if ~isempty(a)
    for i=1:length(a)
        gtInd = a(i);
        lbl=get_obj_label(test_info(gtInd).category);
        confusion(back_lbl,lbl) = confusion(back_lbl,lbl) + 1;
    end 
end

% -get tp for background using the pre-computed segments. If a segment has
% no overlap with gtBB or a prediction then its tp.
% -this assumes that predictions which did not have IOU>0.5 with any segment
% where discarded during the detection process.
hypoBB=[];
for h=1:size(hypos,2)
    hbb = hypos{h}.bb;
    hypoBB(h,:) = [hbb(1) hbb(2) hbb(3)-hbb(1) hbb(4)-hbb(2)]; 
end
%testBB = [hypoBB; gtBB]; % collect hypoBBs and gtBBs
seg_cover = zeros(size(segments,2),1);
seg_cover2 = zeros(size(segments,2),1);
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
    
    % find also those that are covered by gtBB and not by a hypo
    if seg_cover(s)==0
        for t=1:size(gtBB,1)
            tBB = gtBB(t,:);
            intersect = rectint(tBB, segBB);
            tBB_area = tBB(3)*tBB(4);
            segBB_area = segBB(3)*segBB(4);
            overlap = intersect / (tBB_area + segBB_area - intersect);
            if overlap>over_thresh, seg_cover2(s)=1; break; end       
        end
    end
    
    
end

b=find(seg_cover==0); bc=find(seg_cover2==1);
confusion(back_lbl,back_lbl) = confusion(back_lbl,back_lbl) + length(b) - length(bc); % add background tp to conf

% l=size(hypos,2);
% if ~isempty(b) % add the segments as background hypo predictions
%     for i=1:length(b)
%         ind = b(i); 
%         hypos{l+i}.score = 0;
%         hypos{l+i}.bb = segments{ind}.bb;
%         hypos{l+i}.prediction = back_lbl;
%         hypos{l+i}.probs = zeros(length(classes),1);
%     end
% end




            