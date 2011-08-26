function batchplot(vec,x,y,type)
% This is a function that takes over making multiple bar plots for a series
% of input vectors (in cell format)

    % plots the raw data values in the cell array
if strcmp(type,'spoint')
    m = 0;
    for i=1:length(vec)
        if max(vec{i})>m
            m = max(vec{i});
        end
    end
    figure;
    for i=1:length(vec)
        subplot(x,y,i),plot(vec{i},'bd');
        axis([1 length(vec{i}) 0 m]);
        set(gca,'xtickMode','auto','ytickMode','auto');
    end
    %plots histograms of the raw data in the cell array
elseif strcmp(type,'hist')
    mx = 0;
    for i=1:length(vec)
        if max(vec{i})>mx
            mx = max(vec{i});
        end
    end
    bin = (0:mx); 
    h = cell(length(vec),1);
    my = 0;
    for i=1:length(vec)
        h{i} = hist(vec{i},bin);
        if max(h{i}/length(vec{i}))>my
            my = max(h{i}/length(vec{i}));
        end
    end
    figure;
    for i=1:length(vec)
        subplot(x,y,i),bar(bin,h{i}/length(vec{i}),'histc');
        axis([0 mx 0 my]);
        set(gca,'xtickMode','auto','ytickMode','auto');
    end
    % plots scatter plots of the two cell arrays
elseif strcmp(type,'scatter')
    mx = 0;
    my = 0;
    for i=1:length(vec{1})
        if max(vec{1}{i})>mx
            mx = max(vec{1}{i});
        end
        if max(vec{2}{i})>my
            my = max(vec{2}{i});
        end
    end
    figure;
    for i=1:length(vec{1})
        subplot(x,y,i),scatter(vec{1}{i},vec{2}{i});
        axis([0 mx 0 my]);
        set(gca,'xtickMode','auto','ytickMode','auto');
    end
    % plots scatter plots of the two cell arrays after jittering the values
elseif strcmp(type,'jscatter')
    mx = 0;
    my = 0;
    for i=1:length(vec{1})
        rx = 0.25*randn(length(vec{1}{i}),1);
        ry = 0.25*randn(length(vec{1}{i}),1);
        rx = max(rx,-0.4);
        rx = min(rx,0.4);
        ry = max(ry,-0.4);
        ry = min(ry,0.4);
        vec{1}{i} = vec{1}{i}+rx;
        vec{2}{i} = vec{2}{i}+ry;
        if max(vec{1}{i})>mx
            mx = max(vec{1}{i});
        end
        if max(vec{2}{i})>my
            my = max(vec{2}{i});
        end
    end
    figure;
    for i=1:length(vec{1})
        subplot(x,y,i),scatter(vec{1}{i},vec{2}{i});
        axis([0 mx 0 my]);
        set(gca,'xtickMode','auto','ytickMode','auto');
    end
elseif strcmp(type,'confidence')
    m = max(vec(:,3));
    vec(:,3) = vec(:,3)-vec(:,1);
    vec(:,2) = vec(:,1)-vec(:,2);
    figure;
    for i=1:x
        subplot(x,1,i),errorbar(1:size(vec,1)/x,vec((i-1)*y+1:i*y,1),...
            vec((i-1)*y+1:i*y,2),vec((i-1)*y+1:i*y,3),'xb');
        axis([0.5 size(vec,1)/x+0.5 0 m]);
        set(gca,'xtickMode','auto','ytickMode','auto');
    end
elseif strcmp(type,'ratio')
    r = vec(:,2)./(vec(:,1)+vec(:,2));
    m = max(r(:));
    figure;
    for i=1:x
        subplot(x,1,i),plot(1:size(vec,1)/x,r((i-1)*y+1:i*y),'bd');
        axis([0.5 size(vec,1)/x+0.5 0 m]);
        set(gca,'xtickMode','auto','ytickMode','auto');
    end
end