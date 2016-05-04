source configuration.sh

./go_clean.sh
echo "DONE CLEANING"
./go_train.sh
echo "DONE TRAINING"
./go_validation.sh
echo "DONE VALIDATING"
./go_learn.sh
echo "DONE LEARNING"
./go_test.sh
echo "DONE TESTING"

echo "DONE"
echo "COLLECTING RESULTS"
#rm results.res
#echo "FOR COMPARISON REASONS"
#bin/trec_terrier.sh -r -Dtrec.model=${model} -Dtrec.topics=topics.txt -Dtrec.topics.parser=SingleLineTRECQuery 

# TODO: check if other collections ClueWeb09? ClueWeb12? can be improved from the use of readability features
