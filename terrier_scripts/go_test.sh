source configuration.sh

echo "TEST PHASE"
mkdir ${results_dir}
rm test.out

#t=51
#bin/trec_terrier.sh -r -Dtrec.model=${model} -Dtrec.topics=${topics_dir}/topics${t}.test -Dtrec.topics.parser=SingleLineTRECQuery -Dtrec.matching=JforestsModelMatching,FatFeaturedScoringMatching,org.terrier.matching.daat.FatFull -Dfat.featured.scoring.matching.features=FILE -Dfat.featured.scoring.matching.features.file=${features_file} -Dtrec.results.file=${results_dir}/te${t}.res -Dfat.matching.learned.jforest.model=${ensembles_dir}/t${t}/ensemble${t}.txt -Dfat.matching.learned.jforest.statistics=${letors_dir}/t${t}/jforests-feature-stats.txt -Dproximity.dependency.type=SD  

for t in `seq 1 67`; do
bin/trec_terrier.sh -r  -Dtrec.model=${model} -Dtrec.topics=${topics_dir}/topics${t}.test -Dtrec.topics.parser=SingleLineTRECQuery -Dtrec.matching=JforestsModelMatching,FatFeaturedScoringMatching,org.terrier.matching.daat.FatFull -Dfat.featured.scoring.matching.features=FILE -Dfat.featured.scoring.matching.features.file=${features_file} -Dtrec.results.file=${results_dir}/te${t}.res -Dfat.matching.learned.jforest.model=${ensembles_dir}/t${t}/ensemble${t}.txt -Dfat.matching.learned.jforest.statistics=${letors_dir}/t${t}/jforests-feature-stats.txt -Dproximity.dependency.type=SD -Dmatching.retrieved_set_size=${nretrieved} >> test.out 2>> test.out & 
done
wait

cd ${results_dir}
touch ../results.res
for t in `seq 1 67`; do cat te${t}.res >> ../results.res; done
cd -

