# 用仓颉完成编译原理实验
主要算法是正规式转NFA转DFA，消除左递归，消除左公共因子，求FIRTST集和FOLLOW集

初学仓颉，代码原创。
写代码的时候还没系统性学习过仓颉就直接上手写了，写到后面觉得前面写的不好但也没修改，有时间会完善一下代码。

我在CSDN上写了两篇关于这个代码的报告

第一篇：https://blog.csdn.net/2301_76801501/article/details/144850262?fromshare=blogdetail&sharetype=blogdetail&sharerId=144850262&sharerefer=PC&sharesource=2301_76801501&sharefrom=from_link

第二篇：https://blog.csdn.net/2301_76801501/article/details/144866908?fromshare=blogdetail&sharetype=blogdetail&sharerId=144866908&sharerefer=PC&sharesource=2301_76801501&sharefrom=from_link

RegExp_NFA_DFA文件中

输入正规式，将正规式转化为NFA再转化为DFA，输出NFA，DFA的五元组

测试结果为

![image.png](https://raw.gitcode.com/yangmie2/compiling/attachment/uploads/41f1ffc2-958b-4123-9c5b-37e8a2d0a891/image.png 'image.png')
![image.png](https://raw.gitcode.com/yangmie2/compiling/attachment/uploads/41d68ab9-49af-47c9-a242-e9ed3f1e4a20/image.png 'image.png')
![image.png](https://raw.gitcode.com/yangmie2/compiling/attachment/uploads/74679864-ffbb-4829-92e9-31eae84931ad/image.png 'image.png')

Task3文件中

3.1提取间接左递归，提取直接左递归

3.2提取左公共因子

3.3计算FIRST集和FOLLOW集

测试结果为

测试用例1：消除左递归，发现没有间接左递归，消除了直接左递归，打印算法后的文法![image.png](https://raw.gitcode.com/yangmie2/compiling/attachment/uploads/190814b2-59d4-47f2-8f3b-86b548ca66df/image.png 'image.png')
 
测试用例2：消除间接左递归后消除直接左递归，再进行文法的化简，打印文法![image.png](https://raw.gitcode.com/yangmie2/compiling/attachment/uploads/0fce543c-0146-4f4e-b589-c784edbceaf5/image.png 'image.png')

测试用例3：提取左公共因子后发现文法还存在左公共因子，再次进行提取左公共因子计算，打印文法![image.png](https://raw.gitcode.com/yangmie2/compiling/attachment/uploads/fb0aaa1b-a2b8-4ca3-80d8-cb7dcb735e90/image.png 'image.png')
 
测试用例4：求FIRST集，FOLLOW集

![image.png](https://raw.gitcode.com/yangmie2/compiling/attachment/uploads/d00a74d9-4f4a-49c6-aba4-36baec4d9b7c/image.png 'image.png')
 
测试用例5：求FIRST集，FOLLOW集

![image.png](https://raw.gitcode.com/yangmie2/compiling/attachment/uploads/67d67e9c-a91b-431a-9f81-3db0fb6a1441/image.png 'image.png')
