clear all 
current_dir = pwd; % 获取当前路径
Load_Range_Hour=[2 2 2 3 3 3 3 4 5 6 7 7 6 5 5 6 6 6 7 7 6 5 4 3];
[~,Hour_count]=size(Load_Range_Hour);
Case_No=22;
for N_hour=1:1:Hour_count
    
            new_folder = ['第',num2str(N_hour),'小时数据'...
                ];
            mkdir(new_folder);
            cd(new_folder);
            
            N=3600;%一小时有3600秒，假设得到3600组数据
       
            casedata = case22;
            result = runpf(casedata);
            for i = 1 : N
                casedata = case22;
                
                % 每一个负载更新
                casedata.bus(2:Case_No,3) = casedata.bus(2:Case_No,3)*(rand+Load_Range_Hour(Hour_count));%负载波动
                for j = 2 : Case_No
                    % 功率角
                    Temp = acos(rand/10+0.85);
                    % 每一个负载节点无功功率的更新值
                    casedata.bus(j,4) = casedata.bus(j,3)*tan(Temp);
                end
                
                % 潮流计算
                result = runpf(casedata);
                if result.success~=0
                        busdata=result.bus(:,[1:4,8,9]);        
%                  ['节点号' '节点类型' '有功功率' '无功功率' '电压' '相角'];
                        dlmwrite('data.csv',busdata,'-append');
                end
            end
           
        
            
           
      
            close all
            cd(current_dir)
            
            
            
 end
        
 
    
    


