function Score=iforest_Score10(data)
%��ʮ���ظ������Score��������
%% load data
%data=load('breastw_683.csv'); %�ı�����
%data=load('X.csv');
%data=data1;
%data=load('Line_Loss_data2.csv')
ADLabels=data(:,end);
Data=data(:,1:end-1);
 
%% Run iForest
% general parameters
rounds = 10; % rounds of repeat


% parameters for iForest
NumTree = 100; % number of isolation trees
NumSub = 256; % subsample size
NumDim = size(Data, 2); % do not perform dimension sampling 
 

auc = zeros(rounds, 1);
mtime = zeros(rounds, 2);
rseed = zeros(rounds, 1);

Score=zeros(size(Data,1),rounds)
for r = 1:rounds
    disp(['rounds ', num2str(r), ':']);
    
    rseed(r) = sum(100 * clock);
    Forest = IsolationForest(Data, NumTree, NumSub, NumDim, rseed(r));
    mtime(r, 1) = Forest.ElapseTime;
%    [Mass, mtime(r, 2)] = IsolationEstimation(Data, Forest);
    [Mass, ~] = IsolationEstimation(Data, Forest); %Mass�����100������
    Score(:,r) = - mean(Mass, 2);          %ÿһ�м���ƽ��ֵ
    auc(r) = Measure_AUC(Score(:,r), ADLabels);
    disp(['auc = ', num2str(auc(r)), '.']);
%    [~,~,~,AUClog(r)] = perfcurve(logical(ADLabels),Score,'true');    
end

% myresults = [mean(auc), var(auc), mean(mtime(:, 1)), mean(mtime(:, 2))] 

AUC_results = [mean(auc), std(auc)] % average AUC over 10 trials
 
%% Plot AUC based on last trial

for r=1:10
 hold on
[Xlog,Ylog,Tlog,AUClog] = perfcurve(logical(ADLabels),Score(:,r),'true');
plot(Xlog,Ylog) 
xlabel('False positive rate'); ylabel('True positive rate');
title('AUC')
end