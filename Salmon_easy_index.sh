#建立索引
dir=`pwd`
fa="GRCh38.p13.genome.fa"
out_dir="../salmon_easy_hs38"

${dir}/bin/gffread ${gtf} -g ${fa} -w ${out_dir}/trans.fa
cd ${out_dir}
echo "建立快速比对索引中..."
${dir}/bin/salmon index -t trans.fa -i ${out_dir} > index.log
