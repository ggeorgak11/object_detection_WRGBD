
% Georgios Georgakis 2016

function categ = get_category(label)

if label==1, categ='bowl';
elseif label==2, categ='cap';
elseif label==3, categ='cereal_box';
elseif label==4, categ='coffee_mug';
elseif label==5, categ='flashlight';
else categ='soda_can';
end