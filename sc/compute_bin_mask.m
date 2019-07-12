function [sc_mask, mask]  = compute_bin_mask(bin_r,nb_t)
% [sc_mask]  = compute_bin_mask(bin_r,nb_t,nb_o)
%
%
% Liming Wang, Jan 2008
%

%for now bin_r = [0,6,15], nb_t = 12


nb_r            = length(bin_r) -1 ;

[xx,yy] = meshgrid(-bin_r(end):bin_r(end), -bin_r(end):bin_r(end));

mr  = sqrt(xx.*xx+yy.*yy);
mth = atan2(yy,xx);
mth = mod(mth, 2*pi);

ori_unit    = 2*pi/nb_t; %radians for each bin, 3.14/12
ori_bins    = (0:nb_t)*ori_unit;

[fr,fc]     = size(mr);

sc_mask    = zeros(fr*fc,nb_r*nb_t);

for r_bin=1:nb_r
    r_idx   = find(mr>bin_r(r_bin) & mr<=bin_r(r_bin+1));
    mth1    = mth(r_idx);
    for t_bin=1:nb_t
        t_idx	= find(mth1>=ori_bins(t_bin) & mth1<ori_bins(t_bin+1));
        sc_mask(r_idx(t_idx),(r_bin-1)*nb_t+t_bin)=1;
    end
end
sc_mask	= reshape(sc_mask, fr, fc, nb_r*nb_t);
sc_mask	= flipdim(sc_mask,1);
sc_mask	= flipdim(sc_mask,2);

%create a map of the mask to be used later for visualizations
% Georgios Georgakis 2016
mask = zeros(size(sc_mask,1), size(sc_mask,1));
for b=1:size(sc_mask,3)
   
    for i=1:size(sc_mask,1)
        for j=1:size(sc_mask,2)
            if sc_mask(i,j,b)==1
                mask(i,j) = b;
            end
        end
    end
    
end

