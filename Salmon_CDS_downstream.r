library(tximport)
library(rtracklayer)

#人数据读取
hs_gtf="/path/to/gtf/gencode.v38.annotation.gtf"
setwd("/path/to/hs/02.Quanting/")
gtf <- as.data.frame(import(hs_gtf,format="gtf"))
tx2gene <- data.frame(TXNAME=gtf$transcript_id,GENEID=gtf$gene_name)
tx2gene <- tx2gene <- tx2gene[-is.na(tx2gene$TXNAME),]

file_name <- list.files("./")
file_name <- paste0(file_name,"/quant.sf.new")
hs_quant_data <- tximport(files = file_name,type = "salmon",tx2gene = tx2gene)
hs_count_matrix <- round(quant_data$counts)
write.csv(hs_count_matrix,"Hs_count_matrix.csv")

#小鼠数据读取
mm_gtf="/path/to/gtf/gencode.vM27.annotation.gtf"
setwd("/path/to/mm/02.Quanting/")
gtf <- as.data.frame(import(mm_gtf,format="gtf"))
tx2gene <- data.frame(TXNAME=gtf$transcript_id,GENEID=gtf$gene_name)
tx2gene <- tx2gene <- tx2gene[-is.na(tx2gene$TXNAME),]

file_name <- list.files("./")
file_name <- paste0(file_name,"/quant.sf.new")
Mm_quant_data <- tximport(files = file_name,type = "salmon",tx2gene = tx2gene)
Mm_count_matrix <- round(quant_data$counts)
write.csv(Mm_count_matrix,"Mm_count_matrix.csv")
