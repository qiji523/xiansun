clear all 
current_dir = pwd; % ��ȡ��ǰ·��
% N=input('����ѭ������N ��Χ��1000-2000\n');
% R_scale=input('������ϵ�������ϵ��800-1000\n');
% alpha=input('������Ϸ�������0.01-0.1\n');
% N = 1000;  %ѭ������
%%%%��������ģ��
% %%N_min,Nmax,Ncount
% R_scale_min R_scale_max,R_scale_count
%alpha_min,alpha_max,alpha_count
% %%
%  alpha=0.01;
N_min=input('����ѭ������N_min,max,count ��Χ��1000-2000\n');
N_max=input('\n');
N_count=input('\n');
R_scale_min=input('������ϵ�������ϵ����Χ��500-2000_scale_min,max,count0\n');
R_scale_max=input('\n');
R_scale_count=input('\n');
alpha_min=input('������Ϸ�������R_scale_min��max,count �緶Χ��0.01-0.1\n');
alpha_max=input('\n');
alpha_count=input('\n');

for N=N_min:(N_max-N_min)/(N_count-1):N_max
    
    for R_scale=R_scale_min:(R_scale_max-R_scale_min)/R_scale_count:R_scale_max
        for alpha=alpha_min:(alpha_max-alpha_min)/alpha_count:alpha_max
            
            flag=zeros(N+1,1);
            Gen_Power = zeros(N+1,1);
            Line_Loss = zeros(N+1,1);
            X = zeros(N+1,68); %���ؽڵ���й�����
            % ���ؽڵ��й����ʵĸı����
            casedata = case69;
            result = runpf(casedata);
            [M, ~] = size(result.branch);
            % ����ÿһ�����ߵ��������
            for l = 1 : M
                Line_Loss(1) = Line_Loss(1) + abs(abs(result.branch(l,14))-abs(result.branch(l,16)));
            end
            % ���������
            Gen_Power(1) = result.gen(1,2);
            for i = 1 : N
                casedata = case69;
                
                % ÿһ�����ؽڵ��й����ʵĸ���ֵ
                casedata.bus(2:69,3) = casedata.bus(2:69,3)*(1+i*(1/N));%�����޸�
                for j = 2 : 69
                    % ���ʽ�
                    Temp = acos(rand/10+0.85);
                    % ÿһ�����ؽڵ��޹����ʵĸ���ֵ
                    casedata.bus(j,4) = casedata.bus(j,3)*tan(Temp);
                end
                
                if rand<alpha
                    flag(i+1)=1;
                    casedata.branch(3,3)=casedata.branch(3,3)*(rand*R_scale+1000);%�����޸�,��������R�Ĵ�С
                end
                
                
                % ��������
                result = runpf(casedata);
                if result.success~=0
                    [M, ~] = size(result.branch);
                    % ����ÿһ�����ߵ��������
                    for l = 1 : M
                        Line_Loss(i+1) = Line_Loss(i+1) + abs(abs(result.branch(l,14))-abs(result.branch(l,16)));
                    end
                    % ���������
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
            data=data(1:end-1,:);%������1001�����ݣ�Ϊ�˺ÿ�����1000�����ݣ�Ҳ���Ը�matpower���������ɵĳ���
            ADLabel=data(:,end);
            Data=data(:,1:end-1);
            
            idx=kmeans(Data,2);
            
            data1=data(find(idx==1),:);
            data2=data(find(idx==2),:);
            disp('�쳣����  �����')
            disp([find(ADLabel==1),idx(find(ADLabel==1))]);%�쳣�ڵ���š����
            
            
            %-------�Ⱦ�����isolationɭ��
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
            
            %---------------�쳣������һ��
            Score_01=mapminmax(Score',0,1)';%��һ���Ƕ����������е�,01�����һ����10��������
            figure
            plot(Score_01,'b*')
            hold on
            plot(find(ADLabel==1),Score_01(find(ADLabel==1)),'ro')
            title('����֮��������ɭ�ֵ��쳣����')
            
            % new_folder = ['H:/��Ŀ-ͼ�������ĺ���/xiansun/�쳣���/processing/��������/����',...
            % '  N=',num2str(N),...
            % '  R_scale=',num2str(R_scale),...
            % '  alpha=',num2str(alpha)];
            
            new_folder = ['����',...
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


