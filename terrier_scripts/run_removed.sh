
model=BM25

for qrels in "gradrel" "readTRel" "readP1TRel" "binrel" "readOnly"; do
    #for feat in "ir" "all" "read"; do
    for feat in "all_removed_formulas" "all_removed_general" "all_removed_medical" "all_removed_surface"; do
        variation=${qrels}_feat${feat}_1000
        echo "RUNNING $variation"

        # Generates configuration.sh
        echo "topics_dir=\${PWD}/topics/" > configuration.sh
        echo "letors_dir=\${PWD}/letors/" >> configuration.sh
        echo "results_dir=\${PWD}/results_letor/" >> configuration.sh
        echo "ensembles_dir=\${PWD}/ensembles/" >> configuration.sh
        echo "nretrieved=1000" >> configuration.sh
        echo "model=${model} " >> configuration.sh
       
        if [ ${qrels} == "binrel" ]; then
            echo "qrels=/data/palotti/clef/clef15_baselines/qrels/qrels.eng.clef2015.test.bin.txt" >> configuration.sh
        elif [ ${qrels} == "gradrel" ]; then
            echo "qrels=/data/palotti/clef/guido-terrier/terrier-4.0/qrels/qrels_relevance_graded.txt" >> configuration.sh
        elif [ ${qrels} == "readTRel" ]; then
            echo "qrels=/data/palotti/clef/guido-terrier/terrier-4.0/qrels/qrels_readTRel.txt" >> configuration.sh
        elif [ ${qrels} == "readP1TRel" ]; then
            echo "qrels=/data/palotti/clef/guido-terrier/terrier-4.0/qrels/qrels_readP1TRel.txt" >> configuration.sh
        elif [ ${qrels} == "readOnly" ]; then
            echo "qrels=/data/palotti/clef/guido-terrier/terrier-4.0/qrels/qrels_readability_graded.txt" >> configuration.sh
        fi

        echo "features_dir=\${PWD}/etc/" >> configuration.sh
        echo "features_file=\${features_dir}/features_${feat}.list" >> configuration.sh

        # Runs commands
        ./go_all.sh
        
        # move output
        mkdir results/result_${variation}
        mv results_letor results/result_${variation}
        mv configuration.sh results/result_${variation}
        mv results.res results/result_${variation}
    done
done

