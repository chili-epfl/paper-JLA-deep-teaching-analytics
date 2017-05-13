IFS=$'\n'       # make newlines the only separator
COUNTER=0

for line in $(cat Train_Evaluate_RF.R.inputs.txt)    
do
    JOBID=$(($COUNTER / 6))
    if (( $COUNTER % 6 == 0 ))           
    then
	echo "#PBS -l select=1:ncpus=1" >> jobs/job$JOBID.sh
	echo "#PBS -l walltime=24:00:00" >> jobs/job$JOBID.sh
    fi
    echo "/homes/kidzik/anaconda2/bin/Rscript /homes/kidzik/paper-JLA-deep-teaching-analytics/src/models/$line" >> jobs/job$JOBID.sh
    let COUNTER=COUNTER+1
done
