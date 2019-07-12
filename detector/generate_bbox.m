
% generate bbox using the voters positions
% Georgios Georgakis 2016

function recog_result = generate_bbox(recog_result)

hypo_list   = recog_result.hypo_list;
vote_record = recog_result.vote_record;
testpos     = recog_result.testpos;
imgsz       = recog_result.imgsz;
valid_vote_idx=recog_result.valid_vote_idx;
nb_test = size(testpos, 1);

for hy=1:size(hypo_list,1)

    idx_code_curhypo= vote_record(hy).voter_id;
    idx_code_curhypo= valid_vote_idx(idx_code_curhypo);
    idx_fea_curhypo = mod(idx_code_curhypo-1, nb_test) + 1; % feature id
    x_pos	= testpos(idx_fea_curhypo, 1);
    y_pos	= testpos(idx_fea_curhypo, 2); 
    cx=hypo_list(hy,1); cy=hypo_list(hy,2);

    x_diff = max(abs(cx-x_pos));
    y_diff = max(abs(cy-y_pos));
    left=cx-x_diff; right=cx+x_diff;
    top=cy-y_diff; bottom=cy+y_diff;

    % check boundaries
    if right>imgsz(2), right=imgsz(2); end;
    if left<1, left=1; end;
    if bottom>imgsz(1); bottom=imgsz(1); end;
    if top<1, top=1; end;

    %bb=[left top right-left bottom-top];
    hypo_bbox(hy,:) = [left top right bottom];

%     figure; imagesc(recog_result.edge); colormap gray; hold on;
%     plot(x_pos, y_pos, 'r.', 'MarkerSize', 5);
%     plot(cx,cy,'r.', 'MarkerSize', 5);
%     rectangle('position', bb, 'EdgeColor', 'm', 'linewidth', 2);
%     hold off;

end

recog_result.hypo_bbox = hypo_bbox;



