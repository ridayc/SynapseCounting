function bppdf = bipoisspdf(x,n,p,lambda)

bppdf = zeros(length(x),1);
b = binopdf(0:n,n,p);
i = (0:n);
for k=1:length(x)
    l = lambda*i/n;
    bppdf(k) = sum(b.*exp(-l).*l.^x(k)./factorial(x(k)));
end