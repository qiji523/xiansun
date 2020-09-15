E_constants=0.5772156649;
N=10;
n=1:10000;
h=log(n)+E_constants;
c=2*h(1:end-1)-(2*(n(1:end-1))./n(2:end));%n的取值范围为2：end
s=2.^(-h(2:end)./c(end));%n的取值范围为2：end
plot(n(2:end),s,'-')
xlabel('n:')