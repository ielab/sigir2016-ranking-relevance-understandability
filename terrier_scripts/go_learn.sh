source configuration.sh
echo "LEARNING PHASE"
echo "REMEMBER TO CLEAN BEFORE USING IT"

#t=51
#bin/anyclass.sh edu.uci.jforests.applications.Runner  --config-file etc/jforests.properties --cmd=generate-bin --ranking --folder ${letors_dir}/t${t}/ --file tr${t}.letor --file val${t}.letor
#bin/anyclass.sh edu.uci.jforests.applications.Runner  --config-file etc/jforests.properties --cmd=train --ranking --folder ${letors_dir}/t${t}/ --train-file ${letors_dir}/t${t}/tr${t}.bin --validation-file ${letors_dir}/t${t}/val${t}.bin --output-model ${ensembles_dir}/t${t}/ensemble${t}.txt 

for t in `seq 1 67`; do
    bin/anyclass.sh edu.uci.jforests.applications.Runner  --config-file etc/jforests.properties --cmd=generate-bin --ranking --folder ${letors_dir}/t${t}/ --file tr${t}.letor --file val${t}.letor >> learn.out 2>> learn.out &
done
wait

for t in `seq 1 67`; do
    bin/anyclass.sh edu.uci.jforests.applications.Runner  --config-file etc/jforests.properties --cmd=train --ranking --folder ${letors_dir}/t${t}/ --train-file ${letors_dir}/t${t}/tr${t}.bin --validation-file ${letors_dir}/t${t}/val${t}.bin --output-model ${ensembles_dir}/t${t}/ensemble${t}.txt >> learn.out 2>> learn.out & 
done
wait

