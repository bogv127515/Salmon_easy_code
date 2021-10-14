# Salmon_easy

## Salmon_easy 目录格式
**运行**
```
cd /path/to/Salmon_easy
tree -lh 
```
**得到显示**

```
.
├── [4.0K]  bin
│   ├── [9.9M]  fastp
│   ├── [2.5M]  gffread
│   └── [201M]  salmon
└── [4.0K]  lib
    ├── [ 89K]  libgcc_s.so.1
    ├── [ 83K]  libgomp.so.1
    ├── [132K]  liblzma.so.0
    ├── [582K]  libm.so.6
    ├── [  32]  libtbbmalloc_proxy.so
    ├── [182K]  libtbbmalloc_proxy.so.2
    ├── [  26]  libtbbmalloc.so
    ├── [811K]  libtbbmalloc.so.2
    ├── [  20]  libtbb.so
    └── [4.5M]  libtbb.so.2

2 directories, 13 files
```
## 文件说明
文件名|说明
--|--:
Salmon_easy_index.sh|提供fasta和gtf文件建立Salmon_easy可转录区域索引
Salmon_easy_processing.sh|Salmon_easy的主要定量Shell脚本
Salmon_easy_downstream.r|Salmon_easy在R中的运行，生成读数矩阵
STAR_local.sh|STAR在本地的方法重建脚本
Salmon_CDS_upstream.sh|Salmon基于CDS区域序列建立索引方法的主要流程
Salmon_CDS_downstream.r|Salmon基于CDS区域序列建立索引方法在R中生成读数矩阵的流程
Mix_upstream.sh|人与小鼠混合文库的索引策略的索引建立和主要定量流程
Mix_downstream.r|人与小鼠混合文库的索引策略在R中生成度数矩阵的流程
