N=1000;
r=rand(N,1);
angle=2*pi*rand(N,1);
x=[r.*sin(angle),r.*cos(angle),zeros(N,1)];
plot(x(:,1),x(:,2),'bo')
hold on
%----------
plot(sin(0:pi/100:2*pi),cos(0:pi/100:2*pi),'r--')
axis equal
hold on
%---------
M=10;
x_anomaly=[rand(M,2)+1,ones(M,1)];
X=[x;x_anomaly];
plot(X(:,1),X(:,2),'bo')
csvwrite('X.csv',X)
