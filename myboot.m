function [mci vci] = myboot(vec,nboot,a)
% prepare the bootstrap parameter estimate vectors
bm = zeros(nboot,1);
bvar = zeros(nboot,1);
n = length(vec);
m = mean(vec);
v = var(vec);
a = 1-a/100;
% perform the bootstrap nboot times and sample the mean and variance
for i=1:nboot
    s = randi(n,n,1);
    bvec = vec(s);
    bm(i) = mean(bvec);
    bvar(i) = var(bvec);
end
% from the parameter distribution find the probality that a value exceeds
% the original sampled value. 
bm = sort(bm);
bvar = sort(bvar);
prm = (find(bm<m,1,'last'))/(nboot+1);
prvar = (find(bvar<v,1,'last'))/(nboot+1);

% calculate the corresponding value for the inverse of the standard normal
bmz0 = norminv(prm,0,1);
bvz0 = norminv(prvar,0,1);

% calculate the acceleration parameters for mean and variance. (Finding out
% how to calculate these wasn't as easy as it should have been.
am = sum((vec-m).^3)/(sum((vec-m).^2))^(3/2)/6;
av = sum(((vec-m).^2-v).^3)/(sum(((vec-m).^2-v).^2))^(3/2)/6;

za = norminv([a/2 1-a/2],0,1);
% calculation of the shifted z values
zam = bmz0+(bmz0+za)./(1-am*(bmz0+za));
zav = bvz0+(bvz0+za)./(1-av*(bvz0+za));
zam = normcdf(zam,0,1);
zav = normcdf(zav,0,1);
% and finally the end result is an estimation of the confidence intervals
mci = bm(ceil(zam*nboot));
vci = bvar(ceil(zav*nboot));