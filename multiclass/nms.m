
% Perform non-maximal suppresion on the hypotheses 
% Keep a probability distribution for each hypo
% Every time I decide to suppress a hypo, I add its score to the
% distribution of the hypo that remains

% Georgios Georgakis 2016

function [valid_hypos, hypos] = nms(hypos, ratioType, over_thresh)

valid = ones(size(hypos,2),1);

for h=1:size(hypos,2)-1
    bb1=hypos{h}.bb;
    score1=hypos{h}.score;
    
    if valid(h)==0, continue; end;
    
    %ind=find(valid_ones==1);
    for i=1+h:size(hypos,2)
        bb2=hypos{i}.bb;
        score2=hypos{i}.score;
        overl = computeIOU(bb1,bb2, ratioType);
        if overl >= over_thresh
            if score1>score2
                valid(i)=0;
                hypos{h}.probs = hypos{h}.probs + hypos{i}.probs; % adding the distribution
            else
                valid(h)=0; 
                hypos{i}.probs = hypos{h}.probs + hypos{i}.probs;
            end;
        end
        
        %over1=computeIOU(bb1,bb2,'o1');
        %over2=computeIOU(bb1,bb2,'o2');        

        if (bb1(1)<=bb2(1) && bb1(2)<=bb2(2) && bb1(3)>=bb2(3) && bb1(4)>=bb2(4))
            % bb1 covers bb2 completely
            if score1>score2, valid(i)=0; hypos{h}.probs=hypos{h}.probs+hypos{i}.probs; end;
        end
        if (bb2(1)<=bb1(1) && bb2(2)<=bb1(2) && bb2(3)>=bb1(3) && bb2(4)>=bb1(4))
            % bb2 covers bb1 completely
            if score2>score1, valid(h)=0; hypos{i}.probs=hypos{h}.probs+hypos{i}.probs; end;
        end
        
        %if valid(h)==0, break; end;
    end
    
end
valid_hypos = find(valid==1);

