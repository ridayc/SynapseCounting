function SynapseMat()
%start by browsing the subfolders
Grids = dir;
count = 0;
%initialize the Synapse struct
Synapse = struct('grid',{},'type',{},'layer',{},'image',{},'xy',{});
%go through all grid folders
for i=1:length(Grids)
    if Grids(i).isdir==1&&~strcmp(Grids(i).name,'.')&&~strcmp(Grids(i).name,'..')
        count = count+1;
        Synapse(count).grid = Grids(i).name;
        Synapse(count).type = {};
        Synapse(count).layer = {};
        Synapse(count).image = {};
        Synapse(count).xy = [];
        Layers = dir(Grids(i).name);
        %go through all cortical layer folders
        for j=1:length(Layers)
            if Layers(j).isdir==1&&~strcmp(Layers(j).name,'.')&&~strcmp(Layers(j).name,'..')
                jname = strcat(Grids(i).name,'/',Layers(j).name);
                TextFiles = dir(strcat(jname,'/*.txt'));
                %go through all text files in the layer folder
                C = {};
                D = {};
                E = {};
                for k=1:length(TextFiles)
                    kname = strcat(jname,'/',TextFiles(k).name);
                    if strcmp(TextFiles(k).name,'fiji.txt')
                        fid = fopen(kname);
                        C = textscan(fid,'%*d %*s %d %*d %f %f %d %*[^\n]','HeaderLines',1,'delimiter','\t');
                        fclose(fid);
                    elseif strcmp(TextFiles(k).name,'image_list.txt')
                        fid = fopen(kname);
                        D = textscan(fid,'%s %*d %*d %d','delimiter','\t');
                        fclose(fid);
                    elseif strcmp(TextFiles(k).name,'Comments.txt')
                        fid = fopen(kname);
                        E = textscan(fid,'%s %d %*[^\n]','delimiter','\t');
                        fclose(fid);
                    end
                end
                %check if fiji.txt and image_list.txt are present in
                %the folder
                if isempty(C)||isempty(D)
                    disp(strcat('A textfile is missing in',' ',Layers(j).name,' in' ,Grids(i).name));
                    break
                else
                    %check if Comments.txt is present. Remove the
                    %corresponding synapses and images
                    if ~isempty(E)
                        for l=1:length(E{2})
                            ind = find(C{4}==E{2}(l));
                            C{1}(ind) = []; C{2}(ind) = []; C{3}(ind) = []; C{4}(ind) = [];
                            ind = find(D{2}==E{2}(l));
                            D{1}(ind) = []; D{2}(ind) = [];
                        end
                    end
                    symid = sort(unique(C{1}));
                    if length(symid)<5
                        disp(strcat('A synapse type is missing in',' ',Layers(j).name,' in Grid ',Grids(i).name));
                    else
                        %number of synapses
                        Ns = length(C{1});
                        %the same layer name for all synapses
                        lname = repmat({Layers(j).name},Ns,1);
                        % name the symmetry type of all synapses
                        tname = lname;
                        tname(C{1}(:)==symid(1)) = {'sing sym'};
                        tname(C{1}(:)==symid(2)) = {'sing asym'};
                        tname(C{1}(:)==symid(3)) = {'doub asym'};
                        tname(C{1}(:)==symid(4)) = {'doub sym'};
                        tname(C{1}(:)==symid(5)) = {'uncertain'};
                        iname = lname;
                        for l=1:length(D{2})
                            iname(C{4}(:)==D{2}(l)) = D{1}(l);
                        end
                        Synapse(count).type = cat(1,Synapse(count).type,tname);
                        Synapse(count).layer = cat(1,Synapse(count).layer,lname);
                        Synapse(count).image = cat(1,Synapse(count).image,iname);
                        Synapse(count).xy = cat(1,Synapse(count).xy,[C{2} C{3}]);
                    end
                end
            end
        end
    end
end

if ~isempty(Synapse)
    save('Synapse.mat','Synapse');
end
clear all
end