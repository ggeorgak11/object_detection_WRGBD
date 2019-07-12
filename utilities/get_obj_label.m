
% Georgios Georgakis 2016

function label = get_obj_label(categ)

if strcmp(categ, 'bowl'), label=1;
elseif strcmp(categ, 'cap'), label=2;
elseif strcmp(categ, 'cereal_box'), label=3;
elseif strcmp(categ, 'coffee_mug'), label=4;
elseif strcmp(categ, 'soda_can'), label=5;
else label=6; % background label
end
