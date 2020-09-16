clear all
data=load('Line_Loss_data2.csv')
data=data(1:end-1,:);%本来有1001个数据，为了好看保留1000个数据，也可以改matpower中数据生成的程序
ADLabel=data(:,end);
Data=data(:,1:end-1);

idx=kmeans(Data,2);

data1=data(find(idx==1),:);
data2=data(find(idx==2),:);
disp('异常点编号  簇类别')
disp([find(ADLabel==1),idx(find(ADLabel==1))]);%异常节点序号、类别

%--------直接isolation森林
figure
Score_N=iforest(data);%不聚类直接孤立森林得到的异常分数
Score_N=mapminmax(Score_N',0,1)';%归一化到[0,1]
figure
plot(Score_N,'b*')
hold on
plot(find(ADLabel==1),Score_N(find(ADLabel==1)),'ro')
title('不聚类进行随机森林的结果')


%-------先聚类再isolation森林
figure
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

%---------------异常分数归一化
Score_01=mapminmax(Score',0,1)';%归一化是对行向量进行的,01代表归一化，10代表数据
figure
plot(Score_01,'b*')
hold on
plot(find(ADLabel==1),Score_01(find(ADLabel==1)),'ro')
title('聚类之后进行随机森林的异常分数')
%----------画三个简单示意图
[~,x1]=sort(Score1);
[~,x2]=sort(Score2);
[~,X]=sort(Score);

figure
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
    plot(data(X(end-10:end),1),data(X(end-10:end),2),'ro')


%-----------------------画论文中第一个图，也就是上图中的subplot(1,3,3)
figure
clf
plot(data1(:,1),data1(:,2),'ko','MarkerSize',4,'LineWidth',0.0001,'MarkerFaceColor','b')
hold on
plot(data2(:,1),data2(:,2),'ko','MarkerSize',4,'LineWidth',0.0001,'MarkerFaceColor','y')

plot(data(X(end-11:end),1),data(X(end-11:end),2),'ro','MarkerSize',10)
xlabel('Gen power')
ylabel('line loss')
title('isolation forest data')



%------------画论文中第二个图，ROC曲线与AUC，不需要了！！！！
%用到已有的函数，需要多组score，需要改ifrest中的Score，否则只保留最后一次循环的score
Score1_10=iforest_Score10(data1);
Score2_10=iforest_Score10(data2);
Score_10=zeros(size(data,1),10);
j=1;k=1;
for i=1:size(data,1)
    if idx(i)==1
        Score_10(i,:)=Score1_10(j,:);
        j=j+1;
    else
        Score_10(i,:)=Score2_10(k,:);
        k=k+1;
    end
end
Score_10=mapminmax(Score_10',0,1)';%归一化
figure
for r=1:10
    hold on
    [Xlog,Ylog,Tlog,AUClog] = perfcurve(logical(ADLabel),Score_10(:,r),'true');
    plot(Xlog,Ylog)
    xlabel('False positive rate'); ylabel('True positive rate');
    title('AUC')
end
axis([-0.2,1,-0.2,1])

%遇到AUC曲线只有一个点的问题，不用MATLAB自带的
%-------AUC曲线不适合于这个问题，改成PR曲线，转到plot_PR
