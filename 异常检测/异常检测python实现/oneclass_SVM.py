# -*- coding: utf-8 -*-
"""
Created on Fri Sep 18 20:06:34 2020

@author: Administrator
"""
import numpy as np
from sklearn import svm
import matplotlib.pyplot as plt
plt.style.use('fivethirtyeight')

 
# use the same dataset
data = np.loadtxt(open("Line_Loss_data2.csv","rb"),delimiter=",",skiprows=0)
#data[0:1000,0:2] = preprocessing.scale(data[0:1000,0:2],axis=0)


Data = data[0:1000,0:2]
ADLabel = data[0:1000,2]

 
clf = svm.OneClassSVM(nu=0.05, kernel='rbf', gamma=0.1)
'''
OneClassSVM(cache_size=200, coef0=0.0, degree=3, gamma=0.1, kernel='rbf',
      max_iter=-1, nu=0.05, random_state=None, shrinking=True, tol=0.001,
      verbose=False)
'''
clf.fit(Data)
RE = clf.predict(Data)
 
# inliers are labeled 1 , outliers are labeled -1
normal = Data[RE == 1]
abnormal = Data[RE == -1]
'''
plt.plot(normal[:, 0], normal[:, 1], 'bx')
plt.plot(abnormal[:, 0], abnormal[:, 1], 'ro')
'''




plt.figure()

xx, yy = np.meshgrid(np.linspace(3, 10, 70), np.linspace(0, 2.5, 50))


Z = clf.decision_function(np.c_[xx.ravel(), yy.ravel()])
Z = Z.reshape(xx.shape) 
plt.contourf(xx, yy, Z, camp=plt.cm.Blues_r)
#plt.contourf(xx, yy, Z, levels=np.linspace(Z.min(), 0, 7), cmap=plt.cm.PuBu)

r1 = plt.scatter(Data[np.argwhere(RE==-1),0,],Data[np.argwhere(RE==-1),1],
                 c='white',s=200, edgecolor='red')
b1 = plt.scatter(Data[np.argwhere(ADLabel==0),0],Data[np.argwhere(ADLabel==0),1],
                 c='white',s=20, edgecolor='k')
                 
b2 = plt.scatter(Data[np.argwhere(ADLabel==1),0],Data[np.argwhere(ADLabel==1),1],
                 c='red',s=20, edgecolor='k')

plt.legend([b1, b2, r1],
           ["regular observations", "abnormal observations","detected outlier"])

plt.title('One Class SVM')
plt.xlabel('Gen  power')
plt.ylabel('Line  Loss')
plt.savefig('zancun3.png', dpi=200,bbox_inches = 'tight')#指定分辨率
plt.show()
