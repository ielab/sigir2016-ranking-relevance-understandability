source configuration.sh
echo "VALIDATION PHASE"
#t=51
#./bin/trec_terrier.sh -r -Dtrec.model=${model} -Dtrec.topics=${topics_dir}/topics${t}.val -Dtrec.topics.parser=SingleLineTRECQuery  -Dmatching.retrieved_set_size=${nretrieved} -Dtrec.matching=FatFeaturedScoringMatching,org.terrier.matching.daat.FatFull -Dfat.featured.scoring.matching.features=FILE -Dfat.featured.scoring.matching.features.file=${features_file} -Dtrec.querying.outputformat=Normalised2LETOROutputFormat -Dquerying.postprocesses.order=QueryExpansion,org.terrier.learning.LabelDecorator -Dquerying.postprocesses.controls=labels:org.terrier.learning.LabelDecorator,qe:QueryExpansion -Dquerying.default.controls=labels:on -Dlearning.labels.file=${qrels} -Dtrec.results.file=${letors_dir}/t${t}/val${t}.letor -Dproximity.dependency.type=SD

rm validation.out

for t in `seq 1 67`; do
./bin/trec_terrier.sh -r -Dtrec.model=${model} -Dtrec.topics=${topics_dir}/topics${t}.val -Dtrec.topics.parser=SingleLineTRECQuery  -Dmatching.retrieved_set_size=${nretrieved} -Dtrec.matching=FatFeaturedScoringMatching,org.terrier.matching.daat.FatFull -Dfat.featured.scoring.matching.features=FILE -Dfat.featured.scoring.matching.features.file=${features_file} -Dtrec.querying.outputformat=Normalised2LETOROutputFormat -Dquerying.postprocesses.order=QueryExpansion,org.terrier.learning.LabelDecorator -Dquerying.postprocesses.controls=labels:org.terrier.learning.LabelDecorator,qe:QueryExpansion -Dquerying.default.controls=labels:on -Dlearning.labels.file=${qrels} -Dtrec.results.file=${letors_dir}/t${t}/val${t}.letor -Dproximity.dependency.type=SD >> validation.out 2>> validation.out &
done
wait
