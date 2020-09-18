# -*- coding: utf-8 -*-
"""
Created on Thu Sep 17 11:01:21 2020

@author: Administrator
"""
import numpy as np
from sklearn.ensemble import IsolationForest
from sklearn.cluster import KMeans
from sklearn import preprocessing   #做数据标准化，z-score
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve,auc
from sklearn import svm


#rng = np.random.RandomState(123)

data = np.loadtxt(open("Line_Loss_data2.csv","rb"),delimiter=",",skiprows=0)
#data[0:1000,0:2] = preprocessing.scale(data[0:1000,0:2],axis=0)


Data = data[0:1000,0:2]
ADLabel = data[0:1000,2]





idx=KMeans(n_clusters=2).fit_predict(Data)  #idx=1,0

data1=data[np.argwhere(idx==0),:]
data1=data1.reshape(data1.shape[0],3)
data2=data[np.argwhere(idx==1),:]
data2=data2.reshape(data2.shape[0],3)


#clf = IsolationForest(max_samples=256,random_state=rng,contamination=0.01)
clf1 = IsolationForest(max_samples=256,contamination=0.01)
clf2 = IsolationForest(max_samples=256,contamination=0.01)
clf1.fit(data1[:,0:2])
clf2.fit(data2[:,0:2])
'''
clf.fit(Data)
plt.plot(-clf.score_samples(Data),'o')
pre_result=clf.predict(Data)
print(np.argwhere(pre_result!=1))
'''
score1=clf1.score_samples(data1[:,0:2])
score2=clf2.score_samples(data2[:,0:2])


score=np.zeros(1000)
j=0
k=0
for i in range(0,1000):
    if idx[i]==0:
        score[i]=score1[j]
        j=j+1
    else:
        score[i]=score2[k]
        k=k+1
score=-score
plt.plot(score,'o')


#画图1：scatter函数
plt.figure()

xx, yy = np.meshgrid(np.linspace(3,10,70), np.linspace(0, 2.5,50))
Z = (clf1.decision_function(np.c_[xx.ravel(), yy.ravel()])+clf2.decision_function(np.c_[xx.ravel(), yy.ravel()]))/2
Z = Z.reshape(xx.shape) 
plt.contourf(xx, yy, Z, camp=plt.cm.Blues_r)


r1 = plt.scatter(Data[np.argsort(-score)[0:12],0,],Data[np.argsort(-score)[0:12],1],
                 c='white',s=200, edgecolor='red')

b1 = plt.scatter(Data[np.argwhere(ADLabel==0),0],Data[np.argwhere(ADLabel==0),1],
                 c='white',s=20, edgecolor='k')
                 
b2 = plt.scatter(Data[np.argwhere(ADLabel==1),0],Data[np.argwhere(ADLabel==1),1],
                 c='red',s=20, edgecolor='k')

plt.legend([b1, b2, r1],
           ["regular observations", "abnormal observations","detected outlier"],
           loc="upper left")

plt.title('IsolationTree')
plt.xlabel('Gen  power')
plt.ylabel('Line  Loss')
plt.savefig('zancun1.png', dpi=200,bbox_inches = 'tight')#指定分辨率
plt.show()



'''
#画图2：plot函数
#np.argsort() 排序
plt.figure()
plt.plot(Data[:,0],Data[:,1],'bo')
plt.plot(Data[np.argsort(-score)[0:12],0,],Data[np.argsort(-score)[0:12],1],'r+')
plt.title('IsolationTree')
plt.xlabel('Gen_power')
plt.ylabel('Line_Loss')
plt.show()
'''


'''
#pos_labels设置的为感兴趣方的标签

#predict_probs前面输出的是0的概率，后面输出的是1的概率，如果不清楚可以只用predict

#查看结果与概率的对应情况

#一般吧流失设置为1，续费设置为0，感兴趣的设置为1
'''

clf = svm.OneClassSVM(nu=0.05, kernel='rbf', gamma=0.01)
score_svm=clf.fit(Data).score_samples(Data)

#画图2：ROC曲线
plt.figure()
fpr,tpr,thresholds = roc_curve(ADLabel,score)
roc_auc= auc(fpr, tpr)
plt.plot(fpr,tpr,linewidth=2,color='darkorange',label='isolation frest (AUC = %0.2f)' % roc_auc)

#SVM的曲线
fpr1,tpr1,thresholds1 = roc_curve(ADLabel,-score_svm)
roc_auc1= auc(fpr1, tpr1)
plt.plot(fpr1,tpr1,linewidth=2,color='deeppink',linestyle=':',label='One-Class SVM (AUC = %0.2f)' % roc_auc1)




plt.xlim([-0.1, 1.0])
plt.ylim([-0.1, 1.05])
plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--')

plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver operating characteristic example')
plt.legend()
plt.savefig('AUC曲线.png', dpi=200,bbox_inches = 'tight')#指定分辨率
plt.show()



