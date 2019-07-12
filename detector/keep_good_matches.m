

function [valid_vote_idx, params] = keep_good_matches(scoresK, params, objstr)

% define match threshold for each object. The threshold was found empirically after running
% each detector on an independent set of training images
% using a uniform threshold for all objects (e.g. 0.83) also produces similar results

% Georgios Georgakis 2016

if strcmp(objstr, 'cap'), params.vote_thresh = 0.82; 
elseif strcmp(objstr, 'cereal_box'), params.vote_thresh = 0.87;
elseif strcmp(objstr, 'soda_can'), params.vote_thresh = 0.85;
elseif strcmp(objstr, 'coffee_mug'), params.vote_thresh = 0.8;
else params.vote_thresh = 0.85; % bowl
end

valid_vote_idx  = find(scoresK>params.vote_thresh);
if (length(valid_vote_idx) < size(scoresK,1)*size(scoresK,2) )
    fprintf(1,'\t matches pruned because of match_score %d\n', size(scoresK,1)*size(scoresK,2) - length(valid_vote_idx));  
end

while size(valid_vote_idx,1)==0 || size(valid_vote_idx,2)==0
    params.vote_thresh = params.vote_thresh - 0.005; 
    valid_vote_idx = find(scoresK>params.vote_thresh); % lower the thresh to find at least some votes
end