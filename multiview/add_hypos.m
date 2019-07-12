
% when two hypos in a track are added on the same frame, then add their bbs
% and make a decision on prediction
% Georgios Georgakis 2016

function frame = add_hypos(frame, f_ind, objstr_list, ind1, ind2)

h1=frame{f_ind}.hypos{ind1}; % already in track
h2=frame{f_ind}.hypos{ind2}; % the new one associated to the same track
new_bb = [min(h1.bb(1),h2.bb(1)) min(h1.bb(2),h2.bb(2)) max(h1.bb(3),h2.bb(3)) max(h1.bb(4),h2.bb(4))];
frame{f_ind}.hypos{ind1}.bb=new_bb;
% choose the prediction, score, probs, give precedence to non-background labels
if h1.prediction==length(objstr_list) 
    frame{f_ind}.hypos{ind1}.prediction=h2.prediction;
    frame{f_ind}.hypos{ind1}.score=h2.score;
    frame{f_ind}.hypos{ind1}.probs=h2.probs;
elseif h1.prediction~=length(objstr_list) && h2.prediction~=length(objstr_list)
    if h1.score<h2.score
        frame{f_ind}.hypos{ind1}.prediction=h2.prediction;
        frame{f_ind}.hypos{ind1}.score=h2.score;
        frame{f_ind}.hypos{ind1}.probs=h2.probs;
    end
end