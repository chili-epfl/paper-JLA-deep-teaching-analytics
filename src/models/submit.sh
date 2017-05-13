for line in $(ls jobs)
do
    echo "qsub -v EXPERIMENT=$line ./jobs/$line"
done
#qsub -v EXPERIMENT=${1} ./experiment.sh
