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
    
    filepath=pwd;           %保存当前工作目录
    cd('F:\异常检测\processing\数据\改变不同的节点_2\node_45')          %把当前工作目录切换到指定文件夹
    save(['node',num2str(node),'.mat'])
    saveas(gcf,['node_45_',num2str(change_),'.jpg'])
    close all
    cd(filepath)
end



%plot_data(data,score,idx,thresold)
%plot_PR(data(:,3),score)