# 开发文档

## 内部接口

reader.json 从.json获取按时序的音符。从文件夹./input中获取。

在文件夹./matrix里输出matrix.json和scale.json
其中matrix.json给出转移矩阵。
scale.json给出矩阵各个行的意义。每行结构为\[duration_beat（按拍记的时长）,pitch（与主音半音差）\]。

作为示例：

matrix.json

```json
[
  [0, 0.6667, 0, 0, 0, 0.3333, 0, 0],
  [0.6, 0, 0, 0, 0.4, 0, 0, 0],
  [0, 0.75, 0, 0.25, 0, 0, 0, 0],
  [0, 0, 0, 0, 0.3333, 0.6667, 0, 0],
  [0, 0.1667, 0.6667, 0.1667, 0, 0, 0, 0],
  [0, 0, 0, 0, 0.5, 0, 0.5, 0],
  [0, 0, 0, 0.2, 0, 0.2, 0.2, 0.4],
  [0, 0, 0, 0, 0, 0, 1, 0]
]
```

scale.json

```json
[
    [-2,1],
    [-2,0.5],
    [0,1],
    [2,1]
]
```

## 工作分配

读取函数reader.m由@pzk23负责，负责将音符统计结果输出为转移矩阵和scale（与主音半音差和时长）。输出为json(or .mat?)
输出函数printer.m由@@zqi-wong负责，负责按照转移矩阵生成随机音乐。输出为midi
