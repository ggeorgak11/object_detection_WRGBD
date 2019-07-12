
% Apply Bayes to update the probabilities of the object categories
% Georgios Georgakis 2016

function tracklets = update_class_prob(tracklets, track_id, fr_id, hy_id, frame)

h=frame{fr_id}.hypos{hy_id}; % get the hypo info from the frame
obsv=h.probs;
x = tracklets{track_id}.class_distr; % current class probs

% calculate normalization factor
for j=1:length(obsv), a(j) = obsv(j)*x(j); end; a=sum(a);

% update the probabilities for each class
for ob=1:length(obsv), x(ob) = (obsv(ob)*x(ob)) / a; end

% save the new distribution and new prediction
tracklets{track_id}.class_distr=x;
[v,index]=max(x);
tracklets{track_id}.prediction=index;