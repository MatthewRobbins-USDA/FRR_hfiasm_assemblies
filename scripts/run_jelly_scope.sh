#!/bin/bash
#SBATCH -A forage_turf
#SBATCH --job-name="run_jellyfish&GenomeScope2"   #name of the job submitted
##SBATCH -p priority-mem #name of the queue you are submitting job to
#SBATCH -p scavenger-mem
##SBATCH -q frr
#SBATCH -q 400thread
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 32              #number of cores/tasks in this job, you get all 20 cores with 2 threads per core with hyperthreading 
##SBATCH --mem-per-cpu=8G
#SBATCH --mem=256G
#SBATCH -t 4-00:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mail-user=matthew.robbins@usda.gov   #enter your email address to receive emails 
#SBATCH --mail-type=BEGIN,END,FAIL #will receive an email when job starts, ends or fails
#SBATCH -o "logs/stdout.%x.%j.%N"     # standard out %j adds job number to outputfile name and %N adds the node name
#SBATCH -e "logs/stderr.%x.%j.%N"     #optional but it prints our standard error

cat `echo $0`
date

#cd ..
module load jellyfish2/2.2.9

base=$1
kmer=$2
ploidy=$3
files=$4
#The last argument (files) can include wildcards, but must be in quotes, like "/path/to/files/*.gz"
#IMPORTANT: jellyfish cannot read gzipped files. They must be uncompressed files

mkdir $base
cd $base

printf "\n\nBase name of this run is $base\n"
printf "Kmer value is $kmer\n"
echo "list of read files is $files"


time jellyfish count -C -m $kmer -s 64G -t 32 \
	-o ${base}_${kmer}k_counts.jf \
	<(zcat -f $files) 
time jellyfish histo -t 32 ${base}_${kmer}k_counts.jf > ${base}_${kmer}k_counts.histo


#### Run GenomeScope2 on the jellyfish results
module load r/4.2.3

mkdir ${base}_${kmer}k_GenomeScope2
Rscript /project/forage_turf/matt.robbins/matt/genomescope2.0/genomescope.R \
	-i ${base}_${kmer}k_counts.histo \
	-o ${base}_${kmer}k_GenomeScope2 \
	-p $ploidy \
	-k $kmer \
	-n $base \
	-m 1000000000


date                          #optional printing out timestamp when the job ends
#End of file
