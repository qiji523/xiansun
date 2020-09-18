%9/18 linling
%输入：N循环次数，对应进行多少次潮流计算；alpha，变异率，发生故障的概率
%输入：node 发生故障的线路编号，在case的branch中可以找到对应哪两个节点之间的连边
%-------------------------1_data_form--------------------

function Line_Loss_data=data_form_fun(N,alpha,node,change_)

flag=zeros(N,1);  %存储是否变异的标签
Gen_Power = zeros(N,1);
Line_Loss = zeros(N,1);
X = zeros(N+1,68); %负载节点的有功功率

for i = 1 : N
    casedata = case69;
    
    % 每一个负载节点有功功率的更新值
    casedata.bus(2:69,3) = casedata.bus(2:69,3)*(0.75+i*0.001);
    for j = 2 : 69
        % 功率角
        Temp = acos(rand/10+0.85);
        % 每一个负载节点无功功率的更新值
        casedata.bus(j,4) = casedata.bus(j,3)*tan(Temp);
    end
    
    %变异
    if rand<alpha
        flag(i)=1;
        casedata.branch(node,3)=casedata.branch(node,3)*(change_+rand*500);
    end
    
    
    % 潮流计算
    result = runpf(casedata);
    if result.success~=0
        [M, ~] = size(result.branch);
        % 线损：每一个连边的线损求和
        for l = 1 : M
            Line_Loss(i) = Line_Loss(i) + abs(abs(result.branch(l,14))-abs(result.branch(l,16)));
        end
        % 发电机功率
        Gen_Power(i) = result.gen(1,2);
        X(i, :) = result.bus(2:69,3)';
    end
end
%当被更改的节点是branch10时为什么会有错误
% flag(Line_Loss==0)=[];
% Gen_Power(Line_Loss==0)=[];
% Line_Loss(Line_Loss==0)=[];

Line_Loss_data=[Gen_Power,Line_Loss,flag]
end