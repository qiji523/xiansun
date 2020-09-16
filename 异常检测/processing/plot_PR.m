%绘制PR曲线
%Score_01为归一化之后的异常分数
function plot_PR(ADLabel,Score_01)
[~,id]=sort(Score_01,'descend');
error_num=sum(ADLabel);
if sum(ADLabel(id(1:2*error_num)))<error_num
    disp('n个异常，前2n个被判断为异常的节点没有包括全部异常节点')
    return
end
xlog=zeros(1,size(ADLabel,1));
ylog=zeros(1,size(ADLabel,1));
for i=1:size(ADLabel,1)
    xlog(i)=sum(ADLabel(id(1:i)))/error_num;%查全率，真正为正的数据中有多少被找到？
    ylog(i)=sum(ADLabel(id(1:i)))/i;%查准率，预测为正的数据中有多少真正为正？
end
figure
plot([0,xlog],[1,ylog],'*-')
hold on
plot(0.01:0.01:1,0.01:0.01:1.1,'r--')
title('PR曲线')
xlabel('查全率')
ylabel('查准率')
end
