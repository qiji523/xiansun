clear all
N=1000;
alpha=0.01;
thresold=10;
node=3;%
node_set=[3,17,21,27,35,39,43,45,46,67,68]
node=45;
for change_=1000:500:10000

    data=data_form_fun(N,alpha,node,change_);
    [score,idx]=data_processing_fun(data);
    
    data_information(data,score,idx)
    xlabel(['node:',num2str(node)])
    
    filepath=pwd;           %���浱ǰ����Ŀ¼
    cd('F:\�쳣���\processing\����\�ı䲻ͬ�Ľڵ�_2\node_45')          %�ѵ�ǰ����Ŀ¼�л���ָ���ļ���
    save(['node',num2str(node),'.mat'])
    saveas(gcf,['node_45_',num2str(change_),'.jpg'])
    close all
    cd(filepath)
end



%plot_data(data,score,idx,thresold)
%plot_PR(data(:,3),score)