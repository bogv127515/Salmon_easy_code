'''
--- 混合文库的数据处理R流程 ----
--- auth：刘家兴 ----
--- date：2021.10.14
'''

library(tximport)
library(rtracklayer)
library(cowplot)
library(ggplot2)

#混合gtf注释信息
mm_gtf <- as.data.frame(import("/path/to/gtf/gencode.vM27.annotation.gtf",format = "gtf"))
tx_mm <- data.frame(TXNAME=mm_gtf$transcript_id,GENEID=mm_gtf$gene_name)
hs_gtf <- as.data.frame(import("/path/to/gtf/gencode.v38.annotation.gtf",format = "gtf"))
tx_hs <- data.frame(TXNAME=hs_gtf$transcript_id,GENEID=hs_gtf$gene_name)
tx_mm$TXNAME <- paste0("Mm_",tx_mm$TXNAME)
tx_mm$GENEID <- paste0("Mm_",tx_mm$GENEID)
tx_hs$TXNAME <- paste0("Hs_",tx_hs$TXNAME)
tx_hs$GENEID <- paste0("Hs_",tx_hs$GENEID)
tx2gene <- rbind.data.frame(tx_hs,tx_mm)

#引入混合文库定量数据
file_list <- paste0(list.files("./"),"/quant.sf")
mix_quant <- tximport(files=file_list,type="salmon",tx2gene = tx2gene)
count_mix <- round(mix_quant$counts)

#读入单独定量结果
hs_sing <- read.csv("./hg38.easy.full.csv",row.names = 1)
mm_sing <- read.csv("./mm27_fast_full.csv",row.names = 1)

#区分不同物种，基因前加前缀，数据过滤
hs_num <- grep(rownames(count_mix),pattern = "Hs")
hs_mix_out <- count_mix[hs_num,]
mm_num <- grep(rownames(count_mix),pattern = "Mm")
mm_mix_out <- count_mix[mm_num,]
mm_mix_out <- mm_mix_out[-which(rowSums(mm_mix_out)==0),]
hs_mix_out <- hs_mix_out[-which(rowSums(hs_mix_out)==0),]

#区分定量方法，准备合并矩阵
colnames(mm_sing) <- paste0("Single_V",1:7)
colnames(mm_mix_out) <- paste0("Combine_V",1:7)
mm_genes <- intersect(rownames(mm_mix_out,mm_sing))
mm_mix_out_d <- as.data.frame(mm_mix_out[mm_genes,])
hs_gene <- intersect(rownames(hs_mix_out),rownames(hs_sing))
hs_mix_out_d <- as.data.frame(hs_mix_out[hs_genes,])

#合并度数矩阵，做热图
hs_bind <- cbind.data.frame(as.data.frame(hs_mix_d),as.data.frame(hs_sing_d))
anno_hs <- data.frame(Method=c(rep("Combine",7),rep("Single",7)),Sample=paste0("Hs_V",1:7))
rownames(anno_hs) <- colnames(hs_bind)
mm_bind <- cbind.data.frame(as.data.frame(mm_mix_d),as.data.frame(mm_sing_d))
anno_mm <- data.frame(Method=c(rep("Combine",7),rep("Single",7)),Sample=paste0("mm_V",1:7))
rownames(anno_mm) <- colnames(mm_bind)
pheatmap(as.matrix(log(hs_bind+1)),clustering_method = "ward.D2",
               annotation_col = anno_hs,show_rownames = F)
pheatmap(as.matrix(log(mm_bind+1)),clustering_method = "ward.D2",
               annotation_col = anno_mm,show_rownames = F)



#PCA processing,top 1000 change genes
vars <- apply(mm_bind,1,var)
mm_pca <- mm_bind[order(vars,decreasing = T)[1:1000],]
vars <- apply(hs_bind,1,var)
hs_pca <- hs_bind[order(vars,decreasing = T)[1:1000],]
pca_res_mm <- prcomp(t(mm_pca),scale. = T)
pca_res_hs <- prcomp(t(hs_pca),scale. = T)
summary(pca_res_hs)
summary(pca_res_mm)
pca_mm_draw <- data.frame(PC1=pca_res_mm[["x"]][,1],PC2=pca_res_mm[["x"]][,2],
                       method=anno_mm$Method,sample=anno_mm$Sample)
pca_hs_draw <- data.frame(PC1=pca_res_hs[["x"]][,1],PC2=pca_res_hs[["x"]][,2],
                          method=anno_hs$Method,sample=anno_hs$Sample)

pca1 <- ggplot(data = pca_mm_draw)+geom_point(aes(x=PC1,y=PC2,shape=method,color=sample),size=3)+
  xlab("PC1(77.07%)")+ylab("PC2(14.42%)")+theme_classic()
pca2 <- ggplot(data = pca_hs_draw)+geom_point(aes(x=PC1,y=PC2,shape=method,color=sample),size=3)+
  xlab("PC1(55.23%)")+ylab("PC2(23.68%)")+theme_classic()
print(plot_grid(pca1,pca2,nrow = 1))





