%����PR����
%Score_01Ϊ��һ��֮����쳣����
function plot_PR(ADLabel,Score_01)
[~,id]=sort(Score_01,'descend');
error_num=sum(ADLabel);
if sum(ADLabel(id(1:2*error_num)))<error_num
    disp('n���쳣��ǰ2n�����ж�Ϊ�쳣�Ľڵ�û�а���ȫ���쳣�ڵ�')
    return
end
xlog=zeros(1,size(ADLabel,1));
ylog=zeros(1,size(ADLabel,1));
for i=1:size(ADLabel,1)
    xlog(i)=sum(ADLabel(id(1:i)))/error_num;%��ȫ�ʣ�����Ϊ�����������ж��ٱ��ҵ���
    ylog(i)=sum(ADLabel(id(1:i)))/i;%��׼�ʣ�Ԥ��Ϊ�����������ж�������Ϊ����
end
figure
plot([0,xlog],[1,ylog],'*-')
hold on
plot(0.01:0.01:1.1,0.01:0.01:1.1,'r--')
title('PR����')
xlabel('��ȫ��')
ylabel('��׼��')
end
