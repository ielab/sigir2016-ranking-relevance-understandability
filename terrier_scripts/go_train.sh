source configuration.sh
echo "TRAINING PHASE"

#t=51
#./bin/trec_terrier.sh -r -Dtrec.model=$model -Dtrec.topics=${topics_dir}/topics${t}.train -Dtrec.topics.parser=SingleLineTRECQuery -Dmatching.retrieved_set_size=${nretrieved} -Dtrec.matching=FatFeaturedScoringMatching,org.terrier.matching.daat.FatFull -Dfat.featured.scoring.matching.features=FILE -Dfat.featured.scoring.matching.features.file=${features_file} -Dtrec.querying.outputformat=Normalised2LETOROutputFormat -Dquerying.postprocesses.order=QueryExpansion,org.terrier.learning.LabelDecorator -Dquerying.postprocesses.controls=labels:org.terrier.learning.LabelDecorator,qe:QueryExpansion -Dquerying.default.controls=labels:on -Dlearning.labels.file=${qrels} -Dtrec.results.file=${letors_dir}/t${t}/tr${t}.letor -Dproximity.dependency.type=SD
rm train.out

for t in `seq 1 30`; do
./bin/trec_terrier.sh -r -Dtrec.model=$model -Dtrec.topics=${topics_dir}/topics${t}.train -Dtrec.topics.parser=SingleLineTRECQuery -Dmatching.retrieved_set_size=${nretrieved} -Dtrec.matching=FatFeaturedScoringMatching,org.terrier.matching.daat.FatFull -Dfat.featured.scoring.matching.features=FILE -Dfat.featured.scoring.matching.features.file=${features_file} -Dtrec.querying.outputformat=Normalised2LETOROutputFormat -Dquerying.postprocesses.order=QueryExpansion,org.terrier.learning.LabelDecorator -Dquerying.postprocesses.controls=labels:org.terrier.learning.LabelDecorator,qe:QueryExpansion -Dquerying.default.controls=labels:on -Dlearning.labels.file=${qrels} -Dtrec.results.file=${letors_dir}/t${t}/tr${t}.letor -Dproximity.dependency.type=SD >> train.out 2>> train.out & 
done
wait

for t in `seq 31 67`; do
./bin/trec_terrier.sh -r -Dtrec.model=$model -Dtrec.topics=${topics_dir}/topics${t}.train -Dtrec.topics.parser=SingleLineTRECQuery -Dmatching.retrieved_set_size=${nretrieved} -Dtrec.matching=FatFeaturedScoringMatching,org.terrier.matching.daat.FatFull -Dfat.featured.scoring.matching.features=FILE -Dfat.featured.scoring.matching.features.file=${features_file} -Dtrec.querying.outputformat=Normalised2LETOROutputFormat -Dquerying.postprocesses.order=QueryExpansion,org.terrier.learning.LabelDecorator -Dquerying.postprocesses.controls=labels:org.terrier.learning.LabelDecorator,qe:QueryExpansion -Dquerying.default.controls=labels:on -Dlearning.labels.file=${qrels} -Dtrec.results.file=${letors_dir}/t${t}/tr${t}.letor -Dproximity.dependency.type=SD >> train.out 2>> train.out & 
done
wait

