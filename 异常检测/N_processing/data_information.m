function data_information(data,score,idx)
%close all
data1=data(find(idx==1),:);
data2=data(find(idx==2),:);
[~,X]=sort(-score);


ADLabel=data(:,end);
disp('�쳣����  �����   �쳣����')
disp([find(ADLabel==1),idx(find(ADLabel==1)),score(find(ADLabel==1))]);%�쳣�ڵ���š����

%----------��������ʾ��ͼ
[~,X]=sort(score);

figure
subplot(1,3,1)
plot(score,'*')
hold on
plot(find(ADLabel==1),score(find(ADLabel==1)),'ro')
title('�쳣����')

subplot(1,3,2)
plot(data1(:,1),data1(:,2),'k*')
hold on
plot(data2(:,1),data2(:,2),'b*')
plot(data(find(ADLabel==1),1),data(find(ADLabel==1),2),'ro')
title('���ݱ�ǩ')

subplot(1,3,3)
plot(data1(:,1),data1(:,2),'k*')
hold on
plot(data2(:,1),data2(:,2),'b*')
plot(data(X(end-10:end),1),data(X(end-10:end),2),'ro')
title('�����쳣����')

end