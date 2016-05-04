#qrels=/data/palotti/clef/clef15_baselines/qrels/qrels.eng.clef2015.test.bin.txt
#qrels=/data/palotti/clef/guido-terrier/terrier-4.0/qrels/qrels_relevance_graded.txt
#qrels=/data/palotti/clef/guido-terrier/terrier-4.0/qrels/qrels_readP1TRel.txt
#qrels=/data/palotti/clef/guido-terrier/terrier-4.0/qrels/qrels_readTRel.txt
#qrels=/data/palotti/clef/guido-terrier/terrier-4.0/qrels/qrels_readability_graded.txt

topics_dir=${PWD}/topics/

letors_dir=${PWD}/letors/
#letors_dir=/data/palotti/clef/guido-terrier/terrier-4.0/code/

features_dir=${PWD}/etc/

ensembles_dir=${PWD}/ensembles/

results_dir=${PWD}/results_letor/

nretrieved=1000

model=BM25

#features_file=${features_dir}/features_all.list
#features_file=${features_dir}/features_ir.list
features_file=${features_dir}/features_read.list
