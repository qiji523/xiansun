%9/18 linling
%���룺Nѭ����������Ӧ���ж��ٴγ������㣻alpha�������ʣ��������ϵĸ���
%���룺node �������ϵ���·��ţ���case��branch�п����ҵ���Ӧ�������ڵ�֮�������
%-------------------------1_data_form--------------------

function Line_Loss_data=data_form_fun(N,alpha,node,change_)

flag=zeros(N,1);  %�洢�Ƿ����ı�ǩ
Gen_Power = zeros(N,1);
Line_Loss = zeros(N,1);
X = zeros(N+1,68); %���ؽڵ���й�����

for i = 1 : N
    casedata = case69;
    
    % ÿһ�����ؽڵ��й����ʵĸ���ֵ
    casedata.bus(2:69,3) = casedata.bus(2:69,3)*(0.75+i*0.001);
    for j = 2 : 69
        % ���ʽ�
        Temp = acos(rand/10+0.85);
        % ÿһ�����ؽڵ��޹����ʵĸ���ֵ
        casedata.bus(j,4) = casedata.bus(j,3)*tan(Temp);
    end
    
    %����
    if rand<alpha
        flag(i)=1;
        casedata.branch(node,3)=casedata.branch(node,3)*(change_+rand*500);
    end
    
    
    % ��������
    result = runpf(casedata);
    if result.success~=0
        [M, ~] = size(result.branch);
        % ����ÿһ�����ߵ��������
        for l = 1 : M
            Line_Loss(i) = Line_Loss(i) + abs(abs(result.branch(l,14))-abs(result.branch(l,16)));
        end
        % ���������
        Gen_Power(i) = result.gen(1,2);
        X(i, :) = result.bus(2:69,3)';
    end
end
%�������ĵĽڵ���branch10ʱΪʲô���д���
% flag(Line_Loss==0)=[];
% Gen_Power(Line_Loss==0)=[];
% Line_Loss(Line_Loss==0)=[];

Line_Loss_data=[Gen_Power,Line_Loss,flag]
end