function [m cin] = confidenceIntervals(vec,name,nboot,a)
cin = zeros(length(vec),2);
m = zeros(length(vec),1);
for i=1:length(vec)
    m(i) = name(vec{i});
    cin(i,:) = bootci(nboot,{name,vec{i}},'alpha',(1-a/100));
end