### 人数据处理 ###

#CDS索引建立
fa="gencode.v38.pc_transcripts.fa"
out_dir="/path/to/ref/salmon_CDS_hs38"
Threads=8
${dir}/bin/salmon index -t -i ${out_dir} > index.log

#定量及去除无效信息
cat ${file_name}|while read name;
do
    sample=$(echo $(echo ${file}|cut -d, -f1))
    fq1=$(echo $(echo ${file}|cut -d, -f2))
    fq2=$(echo $(echo ${file}|cut -d, -f3))
    if [ ! -d 02.CDS_Quanting ];then
       mkdir 02.CDS_Quanting
    fi
${dir}/bin/salmon quant -p ${Threads} -i ${out_dir} \
-l A -1 "./01.clean_data/${sample}_1.clean.fq.gz" \
-2 "./01.clean_data/${sample}_2.clean.fq.gz" \
-o ./02.CDS_Quanting/${sample}/
done

for name in `ls 02.CDS_Quanting `;do 
cd ${name}; 
cat quant.sf | sed "s/|ENSG.*|//" > quant.sf.new; 
    cd ..;
done

### 鼠数据处理 ###

#CDS索引建立
fa="gencode.vM27.pc_transcripts.fa"
out_dir="/path/to/ref/salmon_CDS_Mm27"
Threads=8
${dir}/bin/salmon index -t -i ${out_dir} > index.log

#定量及去除无效信息
cd "/Path/to/Mm_clean"
cat ${file_name}|while read name;
do
    sample=$(echo $(echo ${file}|cut -d, -f1))
    fq1=$(echo $(echo ${file}|cut -d, -f2))
    fq2=$(echo $(echo ${file}|cut -d, -f3))
    if [ ! -d 02.CDS_Quanting ];then
       mkdir 02.CDS_Quanting
    fi
${dir}/bin/salmon quant -p ${Threads} -i ${out_dir} \
-l A -1 "./01.clean_data/${sample}_1.clean.fq.gz" \
-2 "./01.clean_data/${sample}_2.clean.fq.gz" \
-o ./02.CDS_Quanting/${sample}/
done

for name in `ls 02.CDS_Quanting `;do 
cd ${name}; 
cat quant.sf | sed "s/|ENSG.*|//" > quant.sf.new; 
    cd ..;
done

