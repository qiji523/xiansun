load fisheriris
k=evalclusters(meas,'kmeans','CalinskiHarabasz','Klist',[1:6]); %最佳聚类个数
re=kmeans(meas,3)
flag=zeros(length(species),1);
for i=1:length(species)
    if species{i}(1:2)=='se'
        flag(i)=3;
    elseif species{i}(1:2)=='vi'
        flag(i)=2;
    else
        flag(i)=1;
    end
end

sum(flag==re)
