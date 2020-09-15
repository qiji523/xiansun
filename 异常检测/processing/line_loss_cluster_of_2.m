clear all
data=load('Line_Loss_data2.csv')
ADLabel=data(:,end);
Data=data(:,1:end-1);

idx=kmeans(Data,2);

data1=data(find(idx==1),:);
data2=data(find(idx==2),:);

Score1=iforest(data1);
Score2=iforest(data2);

Score=zeros(size(data,1),1);
j=1;k=1;
for i=1:size(data,1)
    if idx(i)==1
        Score(i)=Score1(j);
        j=j+1;
    else
        Score(i)=Score2(k);
        k=k+1;
    end
end

%----------»­Í¼
[~,x1]=sort(Score1);
[~,x2]=sort(Score2);
[~,X]=sort(Score);

clf
subplot(1,3,1)
plot(data1(:,1),data1(:,2),'k*')
hold on
plot(data2(:,1),data2(:,2),'b*')
plot(data(find(ADLabel==1),1),data(find(ADLabel==1),2),'ro')

subplot(1,3,2)
plot(data1(:,1),data1(:,2),'k*')
hold on
plot(data2(:,1),data2(:,2),'b*')
plot(data(X(end-5:end),1),data(X(end-5:end),2),'ro')


subplot(1,3,3)
plot(data1(:,1),data1(:,2),'k*')
hold on
plot(data2(:,1),data2(:,2),'b*')
plot(data(X(end-13:end),1),data(X(end-13:end),2),'ro')

