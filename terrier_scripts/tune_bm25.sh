model=BM25
outdir=tuning_${model}


for a in `seq 1 100`; do
    c=$(echo "scale=2; $a./100." | bc -l)
    outfile="$outdir/${model}_${c}"
    echo $outfile
    bin/trec_terrier.sh -r -Dtrec.model=${model} -Dtrec.topics=topics.txt -Dtrec.topics.parser=SingleLineTRECQuery -Dtrec.results.file=$outfile -c $c
done
