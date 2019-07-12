
% Get IoU (Intersection over union) for two bounding boxes
% Georgios Georgakis 2016

function overlap = computeIOU(bb1,bb2, ratioType)
% assume bb1,bb2 are of the form [left top right bottom]
bb1(3)=bb1(3)-bb1(1); bb1(4)=bb1(4)-bb1(2); 
bb2(3)=bb2(3)-bb2(1); bb2(4)=bb2(4)-bb2(2);

intersection = rectint(bb1,bb2);
bb1_area = bb1(3)*bb1(4);
bb2_area = bb2(3)*bb2(4);
if strcmp(ratioType, 'iou'), overlap = intersection / (bb1_area + bb2_area - intersection);
elseif strcmp(ratioType, 'min'), overlap = intersection / min(bb1_area,bb2_area);
elseif strcmp(ratioType, 'o1'), overlap = intersection / bb1_area;
elseif strcmp(ratioType, 'o2'), overlap = intersection / bb2_area;
else disp('wrong ratiotype'), overlap=0;
end