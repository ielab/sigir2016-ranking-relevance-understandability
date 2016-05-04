source configuration.sh

# Clean everything from last run

rm ${results_dir}/*
for i in `seq 1 67`; do
    rm ${letors_dir}/t${i}/jforest*
    rm ${letors_dir}/t${i}/*.bin
    rm ${letors_dir}/t${i}/*
    rm ${ensembles_dir}/t${i}/*
done
