
% Georgios Georgakis 2016

function candidate_pos = bring_in_bounds(candidate_pos, i, dsize)

if (candidate_pos(i,2) < 1), candidate_pos(i,2)=1; 
elseif (candidate_pos(i,2)>dsize(1)), candidate_pos(i,2)=dsize(1); 
end;

if (candidate_pos(i,1) < 1), candidate_pos(i,1)=1; 
elseif (candidate_pos(i,1)>dsize(2)), candidate_pos(i,1)=dsize(2); 
end;