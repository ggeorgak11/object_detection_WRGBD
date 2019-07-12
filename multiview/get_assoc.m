
% Georgios Georgakis 2016

function hypo_index = get_assoc(segments, vhypos)

hypo_index=[]; hypo_overlap=[];
for s=1:size(segments,2)
    sbb = segments{s}.bb;
    iou=[];
    for h=1:size(vhypos,2)
        hbb = vhypos{h}.bb;
        iou(h) = computeIOU(hbb,sbb,'iou');
    end
    [v,ind]=max(iou);
    if v > 0.5
        hypo_index(s) = ind;
        hypo_overlap(s) = v;
    else
        hypo_index(s) = 0;
        hypo_overlap(s) = 0;
    end
end