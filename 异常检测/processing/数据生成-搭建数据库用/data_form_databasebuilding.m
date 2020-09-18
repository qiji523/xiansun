clear all 
current_dir = pwd; % ��ȡ��ǰ·��
Load_Range_Hour=[2 2 2 3 3 3 3 4 5 6 7 7 6 5 5 6 6 6 7 7 6 5 4 3];
[~,Hour_count]=size(Load_Range_Hour);
Case_No=22;
for N_hour=1:1:Hour_count
    
            new_folder = ['��',num2str(N_hour),'Сʱ����'...
                ];
            mkdir(new_folder);
            cd(new_folder);
            
            N=3600;%һСʱ��3600�룬����õ�3600������
       
            casedata = case22;
            result = runpf(casedata);
            for i = 1 : N
                casedata = case22;
                
                % ÿһ�����ظ���
                casedata.bus(2:Case_No,3) = casedata.bus(2:Case_No,3)*(rand+Load_Range_Hour(Hour_count));%���ز���
                for j = 2 : Case_No
                    % ���ʽ�
                    Temp = acos(rand/10+0.85);
                    % ÿһ�����ؽڵ��޹����ʵĸ���ֵ
                    casedata.bus(j,4) = casedata.bus(j,3)*tan(Temp);
                end
                
                % ��������
                result = runpf(casedata);
                if result.success~=0
                        busdata=result.bus(:,[1:4,8,9]);        
%                  ['�ڵ��' '�ڵ�����' '�й�����' '�޹�����' '��ѹ' '���'];
                        dlmwrite('data.csv',busdata,'-append');
                end
            end
           
        
            
           
      
            close all
            cd(current_dir)
            
            
            
 end
        
 
    
    


