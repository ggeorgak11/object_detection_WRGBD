
% Average Precision as presented in PASCAL VOC paper

% Georgios Georgakis 2016

function ap = getAP(precision, recall)

lev=[];
for i=0:0.1:1
    a=find(recall>i);
    pr = precision(a);
    v_pr = max(pr);
    lev = [lev v_pr];
end
ap=sum(lev)/11;