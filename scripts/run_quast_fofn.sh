#!/bin/bash
#SBATCH -A forage_turf
#SBATCH --job-name="run_quast_fofn"   #name of the job submitted
#SBATCH -p brief-low #name of the queue you are submitting job to
##SBATCH -q frr
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 16               #number of cores/tasks in this job, you get all 20 cores with 2 threads per core with hyperthreading 
#SBATCH -t 02:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mail-user=matthew.robbins@ars.usda.gov   #enter your email address to receive emails 
#SBATCH --mail-type=BEGIN,END,FAIL #will receive an email when job starts, ends or fails
#SBATCH -o "logs/stdout.%x.%j.%N"     # standard out %j adds job number to outputfile name and %N adds the node name
#SBATCH -e "logs/stderr.%x.%j.%N"     #optional but it prints our standard error
date                          #optional this command prints out timestamp when the job is starting in stdout file

#set variables
dir=$1
basename=$2
asmfiles=$3 #file of assembly filenames, one per line

#created variables
workdir=`readlink -e $dir`
outdir=${workdir}/${basename}_quast_out
#create array from asmfiles
mapfile -t files < $asmfiles

mkdir $outdir

#Write the contents of this script to the log
cat $0
echo "The output directory of this run in $outdir"
echo "The basename of this run is $basename"
echo "The assembly file(s): ${files[@]}"

module load quast/5.2.0

#Run quast
quast.py --large \
        -o $outdir \
        -t $SLURM_NPROCS --min-contig 500 \
        `echo ${files[@]}`

date                          #optional printing out timestamp when the job ends
#End of file
