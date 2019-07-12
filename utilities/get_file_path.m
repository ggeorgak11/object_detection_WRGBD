
% Georgios Georgakis 2016

function file = get_file_path(fr, scene_path)

if fr<10, file = [scene_path, '/0000', num2str(fr)];
elseif fr<100, file = [scene_path, '/000', num2str(fr)];
elseif fr<1000, file = [scene_path, '/00', num2str(fr)]; 
else file = [scene_path, '/0', num2str(fr)]; 
end