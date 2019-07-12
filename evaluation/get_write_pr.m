
% output the results
% Georgios Georgakis 2016

function get_write_pr(conf, res, objstr_list, sc, output_path, write, verbose)

lc = length(objstr_list);
for i=1:lc, class(i)=i; end;
conf(2:lc+1,1) = class;
conf(1,2:lc+1) = class;

class_stats = zeros(size(res,1),3);
nClasses=length(objstr_list);
for c=1:size(res,1)
    obj_res = res(c,:); 
    precision = obj_res(1) / (obj_res(1)+obj_res(2));
    if isnan(precision), precision=0; end;
    recall = obj_res(1) / (obj_res(1)+obj_res(4));
    if isnan(recall), recall=0; end;
    class_stats(c,:) = [c precision recall];
    
    % if tp+fp=0, then no gt examples of that class are in the scene
    if obj_res(1)+obj_res(4)==0, nClasses=nClasses-1; end;
end
% get average over the classes that exist in the scene
avg = [sum(class_stats(:,2))/nClasses sum(class_stats(:,3))/nClasses];

if verbose
    conf
    class_stats
    avg
end

% save the results in a text file
if write

    if sc~=0
        fileID = fopen([output_path, 'scene_', num2str(sc),'_result.txt'],'w');
        fprintf(fileID, 'Scene %d results', sc); 
    else
        fileID = fopen([output_path, 'total_result.txt'],'w');
        fprintf(fileID, 'Results over all scenes');
    end
    fprintf(fileID, '\n\n\nObject Labels:Bowl=1,Cap=2,CerealBox=3,CoffeeMug=4,SodaCan=5,Background=6');
    fprintf(fileID, '\nConfusion Matrix (rows are predicted labels and cols are ground truth):');
    if length(class)==7, fprintf(fileID, '\n%5d %5d %5d %5d %5d %5d %5d %5d', conf');
    else fprintf(fileID, '\n%5d %5d %5d %5d %5d %5d %5d', conf'); end;
    fprintf(fileID, '\n\nClass stats:\n'); 
    fprintf(fileID, '%10s %10s %10s','label', 'precision', 'recall');
    fprintf(fileID, '\n%10d %10.5f %10.5f', class_stats');
    fprintf(fileID, '\n\nAvg:\n');
    fprintf(fileID, '%10s %10s', 'precision', 'recall');
    fprintf(fileID, '\n%10.5f %10.5f', avg(1), avg(2));

end
