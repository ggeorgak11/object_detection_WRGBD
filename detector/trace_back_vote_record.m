 function [vote_record,valid_hypo_idx] = trace_back_vote_record(hypo_list, ...
    candidate_pos, params)
% [vote_record,valid_hypo_idx] = trace_back_vote_record(hypo_list,
% candidate_pos,scoresK_scale, vote_disc_rad)
% 
% 
%
%
% Liming Wang, Jan 2008
% Edited by Georgios Georgakis 2016

if(params.obj_aspect_ratio>1), dim = params.obj_height;
else dim = params.obj_height/params.obj_aspect_ratio;
end
params.vote_disc_rad = dim*0.08;

vote_record = []; % zeros(size(match_pos,1),1);

hypo_cnt = size(hypo_list,1);

valid_hypo  = zeros(hypo_cnt,1);

hypoIdx = 0;

%min_vote = round(size(candidate_pos,1) * 0.00167);
%min_vote = 100; %overwrite it temporarily for testing
%min_vote = 40;
%keyboard

%for each hypo, find all the candidate positions that are inside a region
%around the hypo
for hypo=1:hypo_cnt
    dist2= sqrt((candidate_pos(:,1)-hypo_list(hypo,1)).^2 + (candidate_pos(:,2)-hypo_list(hypo,2)).^2);
    [hypo_offset,match_id]  = sort(dist2,'ascend');
    voter_id = find(hypo_offset<=params.vote_disc_rad);
    %length(voter_id)
    %if(length(voter_id)>=min_vote)
        hypoIdx = hypoIdx + 1;
        vote_record(hypoIdx).voter_id = match_id(voter_id);
        valid_hypo(hypo)=1;
    %end
    %keyboard
end

valid_hypo_idx  = find(valid_hypo);
