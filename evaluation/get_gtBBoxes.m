
% get the ground truth bounding boxes depending the level of detection
% Georgios Georgakis 2016

function gtBB = get_gtBBoxes(gt, level_of_detection, objstr, objinst)

gtBB=[];
c=0;
if (level_of_detection == 1) % class detection
    for i=1:size(gt,2)
        test_cat = gt(i).category;
        if strcmp(objstr, test_cat)
            c = c + 1;
            gtBB(c,1) = gt(i).left;
            gtBB(c,2) = gt(i).top;
            gtBB(c,3) = gt(i).right - gt(i).left;
            gtBB(c,4) = gt(i).bottom - gt(i).top;
        end
    end
elseif (level_of_detection==2) % instance detection
    for i=1:size(gt,2)
        test_cat = gt(i).category;
        test_inst = gt(i).instance;
        if strcmp(objstr, test_cat) && str2double(objinst)==test_inst
            c = c + 1;
            gtBB(c,1) = gt(i).left;
            gtBB(c,2) = gt(i).top;
            gtBB(c,3) = gt(i).right - gt(i).left;
            gtBB(c,4) = gt(i).bottom - gt(i).top;
        end
    end
else % generic object detection
    for i=1:size(gt,2)
       %if strcmp('flashlight', gt(i).category), continue; end;
       c = c + 1;
       gtBB(c,1) = gt(i).left;
       gtBB(c,2) = gt(i).top;
       gtBB(c,3) = gt(i).right - gt(i).left;
       gtBB(c,4) = gt(i).bottom - gt(i).top; 
    end
end


