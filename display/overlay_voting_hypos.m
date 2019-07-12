
% Show the voting along with the proposals

function f = overlay_voting_hypos(recog_result, img, params, segments)

% INPUT: recog_result (output of class_specific_detector)
%        segments (proposals)
%        params
%        img
%OUTPUT: f (figure handler)

% Georgios Georgakis 2016

bbs=recog_result.hypo_bbox;
scores=recog_result.score_list;
color='g';

linewidth=3;

f=figure; if ~params.figs_visible, set(gcf,'Visible', 'off'); end; 
imagesc(img); axis off; hold on;

seg_bb = zeros(size(segments,2),4);
for i=1:size(segments,2)
    %if i==17, continue; end
    x=segments{i}.points_2D(1,:);
    y=segments{i}.points_2D(2,:);
    bb(i,:) = [min(x) min(y) max(x) max(y)];
    seg_bb(i,:) = [bb(i,1) bb(i,2) bb(i,3)-bb(i,1) bb(i,4)-bb(i,2)];
    rectangle('position', seg_bb(i,:), 'EdgeColor', 'm', 'linewidth', linewidth);
end

for i=1:size(bbs,1)
    bb = bbs(i,:); score = scores(i);
    vis_bb = [bb(1) bb(2) bb(3)-bb(1) bb(4)-bb(2)];
    rectangle('position', vis_bb, 'EdgeColor', color, 'linewidth', linewidth);
    %rectangle('position', [bb(1) bb(2)-13 bb(3)-bb(1) 13], 'EdgeColor', color, 'FaceColor', color, 'linewidth', 2);
    %text(bb(1)+5, bb(2)-8, [objPred, '  ', num2str(score)], 'Color', 'k', 'FontSize', 35);
    %text(bb(1)+5, bb(2)-8, num2str(score), 'Color', 'k', 'FontSize', 35);
end


valid_idx = recog_result.valid_vote_idx;
candidate_pos = recog_result.candidate_pos;
testpos = recog_result.testpos;

nb_test = size(testpos,1);
testpos_idx = mod(valid_idx-1, nb_test) + 1;
testpos = testpos(testpos_idx,:);


for i=1:size(testpos,1)
    line([testpos(i,1) candidate_pos(i,1)], [testpos(i,2) candidate_pos(i,2)], 'Color', 'y', 'LineWidth', 0.2);
end
plot(testpos(:,1), testpos(:,2), 'r.', 'MarkerSize', 10);
if ~isempty(candidate_pos), plot(candidate_pos(:,1), candidate_pos(:,2), 'g+', 'MarkerSize', 6); end;
hold off;

