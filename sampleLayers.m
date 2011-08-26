function sl = sampleLayers(Synapse)
% This function samples through the different layers and collects
% the number of excitatory and inhibitory synapses in each disector.
% Here we have all our typically used layer names.
names{1} = 'Layer1';
names{2} = 'Layer2_3';
names{3} = 'Layer4';
names{4} = 'Layer5a';
names{5} = 'Layer5b';
names{6} = 'Layer5c';
names{7} = 'Layer5';
names{8} = 'Layer6';

% We sample from all these layers and store the values using the
% SynapseStat function.
val = cell(length(names),2);
for i=1:length(names)
    [valce vale] = SynapseStat(Synapse,names{i},'sing asym');
    val{i,1} = valce;
    val{i,1}{end+1} = vale;
    [valci vali] = SynapseStat(Synapse,names{i},'sing sym');
    val{i,2} = valci;
    val{i,2}{end+1} = vali;
end

% We regard Layer 5 as a single layer (especially since it's not always
% split up into its sublayers).
sl{1,1} = val{1,1};
sl{2,1} = val{2,1};
sl{3,1} = val{3,1};
sl{5,1} = val{8,1};
sl{1,2} = val{1,2};
sl{2,2} = val{2,2};
sl{3,2} = val{3,2};
sl{5,2} = val{8,2};
for i=1:length(val{4,1})
    sl{4,1}{i,1} = vertcat(val{4,1}{i},val{5,1}{i},val{6,1}{i},val{7,1}{i});
    sl{4,2}{i,1} = vertcat(val{4,2}{i},val{5,2}{i},val{6,2}{i},val{7,2}{i});
end