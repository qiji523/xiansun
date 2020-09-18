# -*- coding: utf-8 -*-
"""
Created on Thu Sep 17 17:26:02 2020

@author: Administrator
"""

import numpy as np
from sklearn.neighbors import LocalOutlierFactor
import matplotlib.pyplot as plt

data = np.loadtxt(open("Line_Loss_data2.csv","rb"),delimiter=",",skiprows=0)

Data = data[0:1000,0:2]
ADLabel = data[0:1000,2]


clf=LocalOutlierFactor(n_neighbors=20)

RE=clf.fit_predict(Data)

plt.figure()

xx, yy = np.meshgrid(np.linspace(3, 10, 70), np.linspace(0, 2.5, 50))

clf.novelty=True
Z = clf.decision_function(np.c_[xx.ravel(), yy.ravel()])
Z = Z.reshape(xx.shape) 
#plt.contourf(xx, yy, Z, camp=plt.cm.Blues_r)
plt.contourf(xx, yy, Z, levels=np.linspace(Z.min(), 0, 7), cmap=plt.cm.PuBu)

r1 = plt.scatter(Data[np.argwhere(RE==-1),0,],Data[np.argwhere(RE==-1),1],
                 c='white',s=200, edgecolor='red')
b1 = plt.scatter(Data[np.argwhere(ADLabel==0),0],Data[np.argwhere(ADLabel==0),1],
                 c='white',s=20, edgecolor='k')
                 
b2 = plt.scatter(Data[np.argwhere(ADLabel==1),0],Data[np.argwhere(ADLabel==1),1],
                 c='red',s=20, edgecolor='k')

plt.legend([b1, b2, r1],
           ["regular observations", "abnormal observations","detected outlier"])

plt.title('Local Outlier Factor')
plt.xlabel('Gen  power')
plt.ylabel('Line  Loss')
plt.savefig('zancun2.png', dpi=200,bbox_inches = 'tight')#指定分辨率
plt.show()
