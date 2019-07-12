
% show the tracks that are created (see multiview.m on how to use)
% Georgios Georgakis 2016

function visualize_tracks(tracklets, frame, tsize, visible)

% visualize large tracks
for t=1:size(tracklets,2)
    tracklen = length(tracklets{t}.flist);
    if tracklen < tsize, continue; end; %ignore small tracklets
    
    tr_pred = tracklets{t}.prediction;
    % uncomment to see the final class distribution of the track
    %tr_class = tracklets{t}.class_distr;

    for fh=1:tracklen % show each frame that the track is in
       fr_id = tracklets{t}.flist(fh);
       hy_id = tracklets{t}.hlist(fh);
       bb=frame{fr_id}.hypos{hy_id}.bb;
       pr=frame{fr_id}.hypos{hy_id}.prediction;

       img=imread([frame{fr_id}.frame_path, '-color.png']);
       
       figure; if ~visible, set(gcf,'Visible', 'off'); end 
       imagesc(img); axis off; 
       title(['Track id:', num2str(t), ' t:', num2str(fh),'/',num2str(tracklen), ...
           '  Frame no:' ,num2str(fr_id), '  Frame Prediction:', num2str(pr), '  Track Pred:', num2str(tr_pred)]);
       hold on; % add the hypo that is tracked           
       vis_bb=[bb(1) bb(2) bb(3)-bb(1) bb(4)-bb(2)];
       rectangle('position', vis_bb, 'EdgeColor', 'g', 'linewidth', 2);
       hold off;

       % uncomment to see the frame class distribution
       %frame{fr_id}.hypos{hy_id}.probs
       
       disp('Press space to continue...');
       pause;
    end       
end
