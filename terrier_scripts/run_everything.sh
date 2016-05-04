# Please set the correct path to the different qrels.


# Choose one of the models to run: (or change this part to a for an run all models)
model=BM25
#model=TF_IDF
#model=PL2
#model=Hiemstra_LM
n=1000

# Select one qrels variant for labeling the documents.
for qrels in "readTRel" "readP1TRel" "binrel" "gradrel" "readOnly" "gradedReadRel"; do
    
    # Select one of the feature variants
    for feat in "ir" "all" "read"; do

        variation=${qrels}_feat${feat}_$n
        echo "RUNNING $variation"

        # Generates configuration.sh
        echo "topics_dir=\${PWD}/topics/" > configuration.sh
        echo "letors_dir=\${PWD}/letors/" >> configuration.sh
        echo "results_dir=\${PWD}/results_letor/" >> configuration.sh
        echo "ensembles_dir=\${PWD}/ensembles/" >> configuration.sh
        echo "nretrieved=${n}" >> configuration.sh
        echo "model=${model} " >> configuration.sh
       
        if [ ${qrels} == "binrel" ]; then
            echo "qrels=/data/palotti/...........qrels/qrels.eng.clef2015.test.bin.txt" >> configuration.sh
        elif [ ${qrels} == "gradrel" ]; then
            echo "qrels=/data/palotti/...........qrels/qrels_relevance_graded.txt" >> configuration.sh
        elif [ ${qrels} == "readTRel" ]; then
            echo "qrels=/data/palotti/...........qrels/qrels_readTRel.txt" >> configuration.sh
        elif [ ${qrels} == "readP1TRel" ]; then
            echo "qrels=/data/palotti/...........qrels/qrels_readP1TRel.txt" >> configuration.sh
        elif [ ${qrels} == "readOnly" ]; then
            echo "qrels=/data/palotti/...........qrels/qrels_readability_graded.txt" >> configuration.sh
        elif [ ${qrels} == "gradedReadRel" ]; then
            echo "qrels=/data/palotti/...........qrels/qrels_gradedReadRel.txt" >> configuration.sh
        fi

        echo "features_dir=\${PWD}/etc/" >> configuration.sh
        echo "features_file=\${features_dir}/features_${feat}.list" >> configuration.sh

        # Runs commands
        ./go_all.sh
        
        # move output
        mkdir results${n}/result_${variation}
        mv results_letor results${n}/result_${variation}
        mv configuration.sh result${n}/result_${variation}
        mv results.res results${n}/result_${variation}
    done
done
