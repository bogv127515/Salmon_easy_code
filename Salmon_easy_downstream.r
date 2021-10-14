library(tximport)
library(rtracklayer)
gtf="gencode.v38.annotation.gtf"
setwd("./02.Quanting/")
gtf <- as.data.frame(import(gtf,format="gtf"))
tx2gene <- data.frame(TXNAME=gtf$transcript_id,GENEID=gtf$gene_name)
tx2gene <- tx2gene <- tx2gene[-is.na(tx2gene$TXNAME),]

file_name <- list.files("./")
file_name <- paste0(file_name,"/quant.sf")
#对于Salmon-CDS file_name <- paste0(file_name,"/quant.sf.new")
quant_data <- tximport(files = file_name,type = "salmon",tx2gene = tx2gene)
count_matrix <- round(quant_data$counts)
