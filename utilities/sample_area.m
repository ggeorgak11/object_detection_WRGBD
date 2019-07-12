
% Georgios Georgakis 2016

function sample = sample_area(pos, area, radius)

pos_x = pos(1);
pos_y = pos(2);
c = 0; sample=[];
% sample around the position
for w = pos_x-radius : pos_x+radius
    for h = pos_y-radius : pos_y+radius
        if w<1 || h<1 || w>size(area,1) || h>size(area,2)
            continue;
        else
            c = c + 1;
            sample(c,:) = [w h];
        end
    end
end