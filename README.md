# 音数小组作业代码部分

此部分为音数小组作业代码部分，由潘昭恺（@pzk23）和王子谦（@zqi-wong）负责。

## 音乐相关

[题目要求](./file/projects22b(1).pdf).
![题目要求](./figure/problem.png)
使用首调？

## 代码与代码结构

计划使用Matlab.
读取json作为转移矩阵。暂时只考虑一阶。

### 工具库

使用工具库JSONlab([GitHub地址](https://github.com/fangq/iso2mesh#fork-destination-box),[下载地址](https://iso2mesh.sourceforge.net/cgi-bin/index.cgi?jsonlab/Download),[相关使用](https://blog.csdn.net/qq_21449473/article/details/123183670))

使用工具库miditoolbox([GitHub地址](https://github.com/miditoolbox/1.1),[文档地址](./file/MIDItoolbox1.1_manual.pdf))

以上工具库皆需在Matlab中读取为路径。

### 交互

（暂不考虑与midi交互？）使用json获取转移矩阵。
两个json文件。
一个是matrix.json,表征转移矩阵。一个是scale.json,表征矩阵的行和主音相差的半音数。
输出midi文件.

### 使用

主函数main.m
matlab命令行中运行脚本。
