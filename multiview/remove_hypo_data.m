
% Georgios Georgakis 2016

function hypos = remove_hypo_data(hypos)

for i=1:size(hypos,2)
    hypos{i} = rmfield(hypos{i},'centroid_2D'); hypos{i} = rmfield(hypos{i},'points_2D');
    hypos{i} = rmfield(hypos{i},'normals');
    hypos{i} = rmfield(hypos{i},'points_3D');
    hypos{i} = rmfield(hypos{i},'mask'); 
end