%9/18 linling
%���룺data N*3�����飬���зֱ�Ϊ��������ʡ�����͡������ǩ
%mode=0ֱ��isolation��mode=1�Ⱦ�����isolation forest
%�����score�쳣������idx�ڵ����ͱ�ǩ
%-----------------2 ���ࡢisolation forest�����쳣����------------------

function [score,idx]=data_processing_fun(data,mode)
if (nargin<2)
    mode=1;
end

ADLabel=data(:,end);
Data=data(:,1:end-1);

idx=kmeans(Data,2);
data1=data(find(idx==1),:);
data2=data(find(idx==2),:);

if mode==0    %ֱ��isolationɭ��
    Score_N=iforest(data);%������ֱ�ӹ���ɭ�ֵõ����쳣����
    Score_N=mapminmax(Score_N',0,1)';%��һ����[0,1]
    score=Score_N
    return
end

%-------�Ⱦ�����isolationɭ��
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

%---------------�쳣������һ��,�Խ����Ӱ��
score=mapminmax(Score',0,1)';%��һ���Ƕ����������е�,01�����һ����10��������
end
