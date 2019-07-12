% Georgios Georgakis 2016

function class_codebook = merge_codebook(class_codebook, instance_codebook)

if isempty(class_codebook)
    class_codebook.codes  = [instance_codebook.codes];
    class_codebook.sc_sum = [instance_codebook.sc_sum];
    class_codebook.relpos = [instance_codebook.relpos];
    class_codebook.location= [instance_codebook.location];
    class_codebook.sc_weight= [instance_codebook.sc_weight];
    class_codebook.img_id = [instance_codebook.img_id];
    class_codebook.pose_id = [instance_codebook.pose_id];
    class_codebook.annolist = [instance_codebook.annolist];
    class_codebook.para = [instance_codebook.para];
else
    class_codebook.codes = [class_codebook.codes; instance_codebook.codes];
    class_codebook.sc_sum= [class_codebook.sc_sum; instance_codebook.sc_sum];
    class_codebook.relpos = [class_codebook.relpos; instance_codebook.relpos];        
    class_codebook.location= [class_codebook.location; instance_codebook.location];
    class_codebook.sc_weight = [class_codebook.sc_weight; instance_codebook.sc_weight];
    %class_codebook.img_id=[class_codebook.img_id; instance_codebook.img_id];
    class_codebook.pose_id=[class_codebook.pose_id; instance_codebook.pose_id];

    ids = size(class_codebook.annolist,2) + instance_codebook.img_id;
    class_codebook.img_id = [class_codebook.img_id ; ids];
    class_codebook.annolist = [class_codebook.annolist' ; instance_codebook.annolist'];      
end