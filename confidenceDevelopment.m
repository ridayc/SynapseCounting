function cid = confidenceDevelopment(vec,nsamp,nboot,loc,rpl,type,a)
% This function performs the function type on random subsamples of vec and
% stores the value. If nboot >= 1 bootstrap confidence intervals will be
% calculated too.
if nboot<1
    cid = zeros(length(loc),nsamp);
    for i=1:length(loc)
        for j=1:nsamp
            if rpl==1
                r = vec(randi(length(vec),loc(i),1));
            else
                r = vec(randperm(length(vec)));
                r = r(1:loc(i));
            end
            cid(i,j) = type(r);
        end
    end
else
    if nargin<6
        a = 95;
    end
    a = 1-a/100;
    cid = zeros(length(loc),3);
    for i=1:length(loc)
        b = zeros(nsamp,1);
        ci = zeros(nsamp,2);
        for j=1:nsamp
            if rpl==1
                r = vec(randi(length(vec),loc(i),1));
            else
                r = vec(randperm(length(vec)));
                r = r(1:loc(i));
            end
            b(j) = type(r);
            ci(j,:) = bootci(nboot,{type,r},'alpha',a);
        end
        cid(i,1) = mean(b);
        cid(i,2) = mean(ci(:,1));
        cid(i,3) = mean(ci(:,2));
    end
end