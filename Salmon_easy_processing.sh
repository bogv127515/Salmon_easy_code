#样本比对

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
-o ./02.Easy_Quanting/${sample}/
done
