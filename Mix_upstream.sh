#!/bin/bash

#混合fasta与gtf文件，做基因组来源和基因标记
#虽然人与小鼠基因大都可通过基因大小写分开，但存在基因名全是大写等无法区分的特殊情况，在此标记

cd /path/to/fasta

cat GRCh38.p13.genome.fa >> hg38.proc.fa
sed -i "s/^>/Hs_/g" hg38.proc.fa
cat GRCm39.genome.fa >> mm27.proc.fa
sed -i "s/^>/Mm_/g" mm27.proc.fa
cat ./*.proc.fa > Mix_hg38_mm27.fa

cd /path/to/gtf

cat gencode.v38.annotation.gtf >> hg38.proc.gtf
sed -i "s/^/Hs_/g" hg38.proc.gtf
cat gencode.vM27.annotation.gtf >> mm27.proc.gtf
sed -i "s/^/Mm_/g" mm27.proc.gtf
cat ./*.proc.gtf > Mix_hg38_mm27.gtf

#建立混合基因组索引
cd /path/to/salmon_easy

dir=`pwd`
fa="/path/to/fa/Mix_hg38_mm27.fa"
gtf="/path/to/gtf/Mix_hg38_mm27.gtf"
out_dir="/path/to/Mix_hg38_mm27_index"

${dir}/bin/gffread ${gtf} -g ${fa} -w ${out_dir}/trans.fa
cd ${out_dir}
echo "建立快速比对索引中..."
${dir}/bin/salmon index -t trans.fa -i ${out_dir} > index.log


#进行质控和快速定量流程
cd /Path/to/salmon_easy

Threads=8
cd /path/to/raw_mix

cat ${file_name}|while read name;
do
    sample=$(echo $(echo ${name}|cut -d, -f1))
    fq1=$(echo $(echo ${name}|cut -d, -f2))
    fq2=$(echo $(echo ${name}|cut -d, -f3))

    if [ ! -d "01.clean_data" ];then
        mkdir "01.clean_data"
    fi
    if [ ! -d "02.Quanting" ];then
        mkdir "02.Quanting"
    fi
    echo "${sample} 过滤中！"
${dir}/bin/fastp -w ${Threads} -i ${fq1} \
-o "./01.clean_data/${sample}_1.clean.fq.gz" \
-I ${fq2} -O "./01.clean_data/${sample}_2.clean.fq.gz"
    echo "${sample} 计数中！"
${dir}/bin/salmon quant -p ${Threads} -i ${out_dir} \
-l A -1 "./01.clean_data/${sample}_1.clean.fq.gz" \
-2 "./01.clean_data/${sample}_2.clean.fq.gz" \
-o ./02.Quanting/${sample}/
done