function [valc val] = SynapseStatn(Synapse,layer,type,n,c,s)
% val will contain the type to be observed in all images in a specific
% layer
valc = cell(length(Synapse),1);
for i=1:length(Synapse)
    temp = strcmp(regexprep(Synapse(i).layer,' ',''),layer);
    l = length(unique(Synapse(i).image(temp)));
    valc{i} = zeros(l,n^2);
    syn = Synapse(i).type(temp);
    loc = Synapse(i).xy(temp,:);
    synim = Synapse(i).image(temp);
    [~,~,indj] = unique(synim);
    for j=1:length(indj)
        if strcmp(syn(j),type)
            x = rem(s,loc(j,1)-c(1));
            y = rem(s,loc(j,2)-c(2));
            x = floor(x/(s/n));
            y = floor(y/(s/n));
            x = min(x,n-1);
            y = min(y,n-1);
            valc{i}(indj(j),x+y*n+1) = valc{i}(indj(j),x+y*n+1)+1;
        end
    end
end

val = [];
for i=1:length(Synapse)
    val(end+1:end+length(valc{i}(:))) = valc{i}(:);
end