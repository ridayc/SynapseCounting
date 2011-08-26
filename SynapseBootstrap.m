function [synmvar synvvar] = SynapseBootstrap(val,numfield,scale,numsample)
% This is a function to bootstrap sample larger fields of synapse and
% observe the cumultative statistics. Typically were measuring the mean
% squared error of the mean and variance under assumption that the mean
% and variance of the whole set are the true values...
synmvar = zeros(numfield,1);
synvvar = zeros(numfield,1);
a = zeros(numsample,1);
b = zeros(numsample,1);
l = length(val);
m = mean(val);
v = var(val);
for i=1:numfield
    r = ceil(l/4*scale^i);
    for j=1:numsample
        a(j) = (mean(val(randi(l,r,1)))-m)^2;
        b(j) = (var(val(randi(l,r,1)))-v)^2;
    end
    synmvar(i) = mean(a);
    synvvar(i) = mean(b);
end