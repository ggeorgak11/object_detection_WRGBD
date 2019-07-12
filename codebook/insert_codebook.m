

% Georgios Georgakis 2016

function codebook = insert_codebook(codebook, codebook1)

if(isempty(codebook))
    codebook.codes  = [codebook1.codes];
    codebook.sc_sum = [codebook1.sc_sum];
    codebook.relpos = [codebook1.relpos];
    codebook.location= [codebook1.location];
    codebook.sc_weight= [codebook1.sc_weight];
    codebook.img_id = [codebook1.img_id];
    codebook.pose_id = [codebook1.pose_id];
else
    codebook.codes = [codebook.codes; codebook1.codes];
    codebook.sc_sum= [codebook.sc_sum;codebook1.sc_sum];
    codebook.relpos = [codebook.relpos; codebook1.relpos];        
    codebook.location= [codebook.location; codebook1.location];
    codebook.sc_weight = [codebook.sc_weight; codebook1.sc_weight];
    codebook.img_id=[codebook.img_id; codebook1.img_id];
    codebook.pose_id=[codebook.pose_id; codebook1.pose_id];
end

