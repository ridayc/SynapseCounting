function [valc val] = SynapseStat(Synapse,layer,type)
% val will contain the type to be observed in all images in a specific
% layer
valc = cell(length(Synapse),1);
for i=1:length(Synapse)
    temp = strcmp(regexprep(Synapse(i).layer,' ',''),layer);
    l = length(unique(Synapse(i).image(temp)));
    valc{i} = zeros(l,1);
    syn = Synapse(i).type(temp);
    synim = Synapse(i).image(temp);
    [~,~,indj] = unique(synim);
    for j=1:length(indj)
        if strcmp(syn(j),type)
            valc{i}(indj(j)) = valc{i}(indj(j))+1;
        end
    end
end

val = [];
for i=1:length(Synapse)
    val(end+1:end+length(valc{i})) = valc{i}(:);
end
val = val';