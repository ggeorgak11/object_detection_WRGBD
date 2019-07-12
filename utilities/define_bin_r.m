
% Choose the radius parameter for each object

% The radius of the bins for each object were determined by running an
% experiment on a validation set.
% Alternatively, one can use a default: e.g. [0,10,30,60], [0,6,15,35]

% Georgios Georgakis 2016

function bin_r = define_bin_r(objstr)

if strcmp(objstr, 'cap'), bin_r = [0, 14, 31, 67];
elseif strcmp(objstr, 'cereal_box'), bin_r = [0, 17, 34, 80];
elseif strcmp(objstr, 'bowl'), bin_r = [0, 14, 29, 63];
elseif strcmp(objstr, 'soda_can'), bin_r = [0, 14, 26, 52];
elseif strcmp(objstr, 'flashlight'), bin_r = [0, 5, 26, 61];
elseif strcmp(objstr, 'coffee_mug'), bin_r = [0, 14, 26, 40];
end