
function frame_new = populate_frame_struct(tracklets, frame, params, objstr_list)

% use the tracklets and their final predictions to calculate the new results
% populate a struct holding the frames info and then save the vhypos individually
% Georgios Georgakis 2016

frame1 = frame{1};
frame_new=cell(1,length(frame)); %frame_new{1}.hypos=[];
for i=1:length(frame_new), frame_new{i}.hypos=[]; end; % create the new cell array

length_thresh = round(size(frame,2)*params.support_per); % thresh on the min length of the valid tracks
for tr=1:size(tracklets,2)
    tracklen = length(tracklets{tr}.flist);
    tr_prediction = tracklets{tr}.prediction; % the final prediction of the track
    % if a track is small and not labelled as background then discard it
    if tracklen < length_thresh && tr_prediction~=length(objstr_list), continue; end;

    for t=1:tracklen
        fr_id = tracklets{tr}.flist(t);
        hy_id = tracklets{tr}.hlist(t);
        % substitute the frame pred with the track pred
        if fr_id==1
            frame1.hypos{hy_id}.prediction = tr_prediction;
            frame_new{1}.hypos{end+1} = frame1.hypos{hy_id};
            frame_new{1}.frame_path = frame1.frame_path;
        else
            frame{fr_id}.hypos{hy_id}.prediction = tr_prediction;
            frame_new{fr_id}.hypos{end+1} = frame{fr_id}.hypos{hy_id};
            frame_new{fr_id}.frame_path = frame{fr_id}.frame_path;
        end
    end        
end
    
    
    