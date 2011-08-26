function bppdf = bipoisspdf2(x,n,p,lambda,maxit)

bppdf = zeros(length(x),1);
b = zeros(maxit,1);
if 1-p>p
    p=1-p;
end
for j=0:n
    for i=0:maxit
        b(j+1) = b(j+1)+prod(n*ones(i+1,1)-(0:i)')/factorial(i)...
            *p^(n-i)*(1-p)^i;
    end
end
i = (0:n);
for k=1:length(x)
    l = lambda*i/n;
    bppdf(k) = sum(b.*exp(-l).*l.^x(k)./factorial(x(k)));
end