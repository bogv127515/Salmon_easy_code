### 人数据处理 ###
#建立索引
time STAR  --runMode genomeGenerate --runThreadN 8 \
    --genomeDir /path/to/STAR_Hs_reference \
    --genomeFastaFiles GRCh38.p13.genome.fa \
--sjdbGTFfile gencode.v38.annotation.gtf

#比对并计时
cd "/Path/to/hs/clean"
time for name in `ls |cut -d_ -f1|uniq`;do
    FQ1=${name}_clean.1.fq.gz
    FQ2=${name}_clean.2.fq.gz
    if[ ! -d ../matching/${name} ];then
        mkdir ../matching/${name}
    fi
    STAR --genomeDir /path/to/STAR_Hs_reference \
                --readFilesCommand zcat \
                --genomeLoad NoSharedMemory \
                --outFilterMismatchNmax 20 \
                --runThreadN 8 --readFilesIn ${FQ1} ${FQ2} \
                --outFileNamePrefix ../matching/${name}/${name}. \
                --outFilterMultimapNmax 10 \
                --outSAMtype BAM SortedByCoordinate\
                --limitBAMsortRAM 20000000000
done
#从比对文件中定量
time featureCounts -a gencode.v38.annotation.gtf -p -T8 \
                -o out_file.txt -g gene_name ./matching/*/*.bam
#提取计数矩阵

cat out_file.txt | cut -f 7-18> count.Hs.txt

### 小鼠数据处理 ###
#建立索引
time STAR  --runMode genomeGenerate --runThreadN 8 \
    --genomeDir /path/to/STAR_Mm_reference \
    --genomeFastaFiles GRCm39.genome.fa \
    --sjdbGTFfile gencode.vM27.annotation.gtf

cd "/Path/to/mm/clean"

#比对并计时
time for name in `ls |cut -d_ -f1|uniq`;do
    FQ1=${name}_clean.1.fq.gz
    FQ2=${name}_clean.2.fq.gz
    if[ ! -d ../matching/${name} ];then
        mkdir ../matching/${name}
    fi
    STAR --genomeDir /path/to/STAR_Mm_reference \
                --readFilesCommand zcat \
                --genomeLoad NoSharedMemory \
                --outFilterMismatchNmax 20 \
                --runThreadN 8 --readFilesIn ${FQ1} ${FQ2} \
                --outFileNamePrefix ../matching/${name}/${name}. \
                --outFilterMultimapNmax 10 \
                --outSAMtype BAM SortedByCoordinate\
                --limitBAMsortRAM 20000000000
done
#从比对文件中定量
time featureCounts -a gencode.vM27.annotation.gtf -p -T 8 \
                -o out_file.txt -g gene_name ./matching/*/*.bam
#提取计数矩阵

cat out_file.txt | cut -f 7-13> count.Mm.txt
