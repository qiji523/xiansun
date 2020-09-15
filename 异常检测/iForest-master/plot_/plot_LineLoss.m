hold on
[~,x]=sort(Score)
subplot(2,3,1)
plot(data(:,1),data(:,2),'*')
hold on
plot(data(find(ADLabels==1),1),data(find(ADLabels==1),2),'ro')
subplot(2,3,2)
plot(data(:,1),data(:,2),'*')
hold on
plot(data(x(end-5:end),1),data(x(end-5:end),2),'ro')
subplot(2,3,3)
plot(data(:,1),data(:,2),'*')
hold on
plot(data(x(end-13:end),1),data(x(end-13:end),2),'ro')


%plot brunch
N=size(branch,1)+1;
A=zeros(N);
for i=1:N-1
    A(branch(i,1),branch(i,2))=1;
    A(branch(i,2),branch(i,1))=1;
end
