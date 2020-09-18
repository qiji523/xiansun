%9/18 linling
%输入：data N*3的数组，三列分别为发电机功率、线损和、变异标签
%mode=0直接isolation，mode=1先聚类再isolation forest
%输出：score异常分数，idx节点类型标签
%-----------------2 聚类、isolation forest计算异常分数------------------

function [score,idx]=data_processing_fun(data,mode)
if (nargin<2)
    mode=1;
end

ADLabel=data(:,end);
Data=data(:,1:end-1);

idx=kmeans(Data,2);
data1=data(find(idx==1),:);
data2=data(find(idx==2),:);

if mode==0    %直接isolation森林
    Score_N=iforest(data);%不聚类直接孤立森林得到的异常分数
    Score_N=mapminmax(Score_N',0,1)';%归一化到[0,1]
    score=Score_N
    return
end

%-------先聚类再isolation森林
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

%---------------异常分数归一化,对结果无影响
score=mapminmax(Score',0,1)';%归一化是对行向量进行的,01代表归一化，10代表数据
end
