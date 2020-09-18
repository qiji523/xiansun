%-----------画论文中第一个图
function plot_data(data,score,idx,thresold)
%close all
%-----------------------画论文中第一个图
data1=data(find(idx==1),:);
data2=data(find(idx==2),:);
[~,X]=sort(-score);

figure
clf
plot(data1(:,1),data1(:,2),'ko','MarkerSize',4,'LineWidth',0.0001,'MarkerFaceColor','b')
hold on
plot(data2(:,1),data2(:,2),'ko','MarkerSize',4,'LineWidth',0.0001,'MarkerFaceColor','y')

plot(data(X(1:thresold),1),data(X(1:thresold),2),'ro','MarkerSize',10)
xlabel('Gen power')
ylabel('line loss')
title('isolation forest data')
end