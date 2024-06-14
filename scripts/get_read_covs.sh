#! /bin/bash
#SBATCH -A forage_turf
#SBATCH --job-name="get_read_covs"   #name of the job submitted
#SBATCH -p priority #name of the queue you are submitting job to
#SBATCH -q frr
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 96               #number of cores/tasks in this job, you get all 20 cores with 2 threads per core with hyperthreading
#SBATCH -t 2-00:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mail-user=matthew.robbins@ars.usda.gov   #enter your email address to receive emails
#SBATCH --mail-type=BEGIN,END,FAIL #will receive an email when job starts, ends or fails
#SBATCH -o "run/logs/stdout.%x.%j.%N"     # standard out %j adds job number to outputfile name and %N adds the node name
#SBATCH -e "run/logs/stderr.%x.%j.%N"     #optional but it prints our standard error
date                          #optional this command prints out timestamp when the job is starting in stdout file

#set variables
base=$1 #The basename
asm=$2 #The absolute path of the assmembly
fofn=$3 #The absolute path of the fofn of the gzip compressed or uncompressed original hifi reads to map to the asm
minimapx=$4 #The minimap preset to use on minmap (map-hifi, map-pb, sr)
#IF minimapx=sr, the paired reads need to be concatenated into a single R1.fasta and R2.fasta before running this script!!!
#and the first line of the script needs to be changed to:
# minimap2 -ax $minimapx -t 96 -c --secondary=no $asm R1.fasta R2.fasta > ${base}_aln.sam

#created variables
asmname=`basename $asm`

#load modules
module load minimap2/2.24 samtools/1.17 bedtools/2.30.0

#Write the contents of the this script to the log
cat $0
echo "The basename of this run is $base"
echo "The assembly file is $asm"
echo "The fofn of the reads is $fofn"
echo "The minimap2 preset is $minimapx"

#make a new directory from the basename so there is a dir for each run from the working directory
mkdir $base
cd $base

# I took out the -c options from minimap2 because I don't think we need the CIGAR output in minimap.  If I break it, I should replace the -c 
xargs cat < $fofn | minimap2 -ax $minimapx -t $SLURM_NPROCS -I 10G -c --secondary=no $asm - > ${base}_aln.sam
samtools view -@ 18 -T $asm -bh -F 256 -F 2048 -o ${base}_aln.bam ${base}_aln.sam
samtools sort -@ 18 -o ${base}_aln_sorted.bam ${base}_aln.bam
samtools index ${base}_aln_sorted.bam
if [ ! -f "${asm}.fai" ]; then
	samtools faidx $asm
fi
bedtools makewindows -g ${asm}.fai -w 10000 -s 5000 > ${asmname}_10kbwindows.bed
#include the -sorted flag to use a more memory efficient algorithm for large files
bedtools coverage -sorted -a ${asmname}_10kbwindows.bed -b ${base}_aln_sorted.bam -mean > ${base}_aln_10kb_cov.bedgraph

date
####################
