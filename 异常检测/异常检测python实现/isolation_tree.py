# -*- coding: utf-8 -*-
"""
Created on Thu Sep 17 11:01:21 2020

@author: Administrator
"""
import numpy as np
from sklearn.ensemble import IsolationForest
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

#rng = np.random.RandomState(123)

data = np.loadtxt(open("Line_Loss_data2.csv","rb"),delimiter=",",skiprows=0)

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

xx, yy = np.meshgrid(np.linspace(3, 10, 70), np.linspace(0, 2.5, 50))
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
plt.savefig('line_loss_data2.png', dpi=200)#指定分辨率
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




