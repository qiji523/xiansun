clear all 
current_dir = pwd; % 获取当前路径
% N=input('输入循环次数N 范围：1000-2000\n');
% R_scale=input('输入故障电阻缩放系数800-1000\n');
% alpha=input('输入故障发生比例0.01-0.1\n');
% N = 1000;  %循环次数
%%%%数据输入模块
% %%N_min,Nmax,Ncount
% R_scale_min R_scale_max,R_scale_count
%alpha_min,alpha_max,alpha_count
% %%
%  alpha=0.01;
N_min=input('输入循环次数N_min,max,count 范围：1000-2000\n');
N_max=input('\n');
N_count=input('\n');
R_scale_min=input('输入故障电阻缩放系数范围：500-2000_scale_min,max,count0\n');
R_scale_max=input('\n');
R_scale_count=input('\n');
alpha_min=input('输入故障发生比例R_scale_min，max,count 如范围：0.01-0.1\n');
alpha_max=input('\n');
alpha_count=input('\n');

for N=N_min:(N_max-N_min)/(N_count-1):N_max
    
    for R_scale=R_scale_min:(R_scale_max-R_scale_min)/R_scale_count:R_scale_max
        for alpha=alpha_min:(alpha_max-alpha_min)/alpha_count:alpha_max
            
            flag=zeros(N+1,1);
            Gen_Power = zeros(N+1,1);
            Line_Loss = zeros(N+1,1);
            X = zeros(N+1,68); %负载节点的有功功率
            % 负载节点有功功率的改变次数
            casedata = case69;
            result = runpf(casedata);
            [M, ~] = size(result.branch);
            % 线损：每一个连边的线损求和
            for l = 1 : M
                Line_Loss(1) = Line_Loss(1) + abs(abs(result.branch(l,14))-abs(result.branch(l,16)));
            end
            % 发电机功率
            Gen_Power(1) = result.gen(1,2);
            for i = 1 : N
                casedata = case69;
                
                % 每一个负载节点有功功率的更新值
                casedata.bus(2:69,3) = casedata.bus(2:69,3)*(1+i*(1/N));%可以修改
                for j = 2 : 69
                    % 功率角
                    Temp = acos(rand/10+0.85);
                    % 每一个负载节点无功功率的更新值
                    casedata.bus(j,4) = casedata.bus(j,3)*tan(Temp);
                end
                
                if rand<alpha
                    flag(i+1)=1;
                    casedata.branch(3,3)=casedata.branch(3,3)*(rand*R_scale+1000);%可以修改,故障类型R的大小
                end
                
                
                % 潮流计算
                result = runpf(casedata);
                if result.success~=0
                    [M, ~] = size(result.branch);
                    % 线损：每一个连边的线损求和
                    for l = 1 : M
                        Line_Loss(i+1) = Line_Loss(i+1) + abs(abs(result.branch(l,14))-abs(result.branch(l,16)));
                    end
                    % 发电机功率
                    Gen_Power(i+1) = result.gen(1,2);
                    X(i+1, :) = result.bus(2:69,3)';
                end
            end
            flag(Line_Loss==0)=[];
            Line_Loss(Line_Loss==0)=[];
            Gen_Power(Gen_Power==0)=[];
            figure
            plot(Gen_Power,Line_Loss,'*')
            hold on
            plot(Gen_Power(flag==1),Line_Loss(flag==1),'ro')
            
            Line_Loss_data=[Gen_Power,Line_Loss,flag]
            % csvwrite('data1.csv',Line_Loss_data)
            
            %----------------------------------------------------
            
            %data=load('data2.csv')
            data=Line_Loss_data;
            data=data(1:end-1,:);%本来有1001个数据，为了好看保留1000个数据，也可以改matpower中数据生成的程序
            ADLabel=data(:,end);
            Data=data(:,1:end-1);
            
            idx=kmeans(Data,2);
            
            data1=data(find(idx==1),:);
            data2=data(find(idx==2),:);
            disp('异常点编号  簇类别')
            disp([find(ADLabel==1),idx(find(ADLabel==1))]);%异常节点序号、类别
            
            
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
            
            % new_folder = ['H:/项目-图计算中文核心/xiansun/异常检测/processing/数据生成/数据',...
            % '  N=',num2str(N),...
            % '  R_scale=',num2str(R_scale),...
            % '  alpha=',num2str(alpha)];
            
            new_folder = ['数据',...
                '  N=',num2str(N),...
                '  R_scale=',num2str(R_scale),...
                '  alpha=',num2str(alpha)];
            mkdir(new_folder);
            cd(new_folder);
            saveas(gcf,'img2.fig')
            save(['idx2.mat'],'idx')
            save('Score2','Score')
            csvwrite('data2.csv',Line_Loss_data)
            close all
            cd(current_dir)
            
            
            
        end
        
    end
    
    
end


