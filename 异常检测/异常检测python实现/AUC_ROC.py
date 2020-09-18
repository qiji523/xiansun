# -*- coding: utf-8 -*-
"""
Created on Fri Sep 18 20:33:48 2020

@author: Administrator
"""
#画ROC曲线与AUC

from sklearn.metrics import roc_curve

#roc_curve输出为tpr、fpr假正和真正概率，且第二个参数一定要是概率估计或者置信度

fpr,tpr,thresholds = roc_curve(Data,score)

#pos_labels设置的为感兴趣方的标签

#predict_probs前面输出的是0的概率，后面输出的是1的概率，如果不清楚可以只用predict

#查看结果与概率的对应情况

#一般吧流失设置为1，续费设置为0，感兴趣的设置为1


plt.plot(fpr,tpr,linewidth=2,color='darkorange',label='ROC curve (area = %0.2f)' % roc_auc[2])

plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.plot([0, 1], [0, 1], color='navy', lw=lw, linestyle='--')

plt.legend(loc=4)#图例的位置
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver operating characteristic example')
plt.legend(loc="lower right")
plt.show()

