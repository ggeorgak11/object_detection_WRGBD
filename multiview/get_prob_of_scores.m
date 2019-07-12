
% Normalize scores to probabilities given the max_v and min_v values found
% in the evaluation set

% Georgios Georgakis 2016

function hypos = get_prob_of_scores(hypos, params)

for i=1:size(hypos,2)
    std_scores = hypos{i}.probs;
    if ~any(std_scores) % if all zeros then background=1
        std_scores(length(std_scores))=params.background_score; 
    end 
    for s=1:length(std_scores) % normalize between min-max
        if std_scores(s)==0 || std_scores(s)<params.min_v
            std_scores(s)=params.zero_score; 
        elseif std_scores(s)>params.max_v
            std_scores(s)=1;
        else
            std_scores(s) = (std_scores(s)-params.min_v) / (params.max_v-params.min_v);
        end
    end
    probs2 = std_scores./sum(std_scores); % normalize between 0...1
    hypos{i}.probs = probs2;
end

