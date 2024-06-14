#!/bin/bash
#SBATCH --job-name="run_hifiasm"
#SBATCH -A forage_turf
#SBATCH -q frr
#SBATCH -p priority-mem #name of the queue you are submitting job to
#SBATCH --mem=0
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 96              #number of cores/tasks in this job, you get all 20 cores with 2 threads per core with hyperthreading 
#SBATCH -t 4-00:00:00           #time allocated for this job hours:mins:seconds
##SBATCH --mail-user=matthew.robbins@ars.usda.gov   #enter your email address to receive emails 
##SBATCH --mail-type=BEGIN,END,FAIL #will receive an email when job starts, ends or fails
#SBATCH -o "logs/stdout.%x.%j.%N"     # standard out %j adds job number to outputfile name and %N adds the node name
#SBATCH -e "logs/stderr.%x.%j.%N"     #optional but it prints our standard error


date

h1=""
h2=""

svalue=""
hom_cov=""
ul_list=""

#The hau is the flags that you want to supply the script you put a colon after arguments that you want to
#have  an argument for that flag.
while getopts hs:H:1:2:u: flag
do
	case "${flag}" in
        	s) svalue="-s ${OPTARG}";;
                H) hom_cov="--h-cov ${OPTARG}";; # The $OPTARG is how you access the flag variable
		1) h1="--h1 ${OPTARG}";;
		2) h2="--h2 ${OPTARG}";;
		u) ul_list="--ul ${OPTARG}";;
		h|\?) echo "help: sbatch run_hifiasm_HiC.sh [options] <basename> <in_files>" # \? This handles unknown flags
                  echo "    Runs a hifiasm HiC assembly"
                  echo "    Options:"
                  echo "      -s               specify an s value other than default"
                  echo "      -H               specify a homozygous read coverage value other than default"
		  echo "      -1	       specify the R1 Hi-C file"
		  echo "      -2	       specify the R2 Hi-C file"
		  echo "      -u	       specify a comma separated list of Ultra-long (ONT) reads"
                  echo "      -h               displays this help menu"
	          echo ""
		  exit 1;;
	esac
done

cat `echo $0`

shift $(($OPTIND -1))

base=$1
in_files=$2 #This can include wildcards like *.fasta.gz BUT IT MUST BE WITHIN DOUBLE QUOTES if used as an argument in the sbatch command

echo
echo "base name of project is $base"
echo "input files for hifiasm is $in_files"
echo "the actual files are:"
ls $in_files
echo "R1 proximity ligation reads file is $h1"
echo "R2 proximity ligation reads file is $h2"
echo "s value is $svalue"
echo "ul files are $ul_list"
echo "hom-cov is $hom_cov"
echo

mkdir $base
cd $base

#Run hifiasm to get assembly

/project/forage_turf/matt.robbins/matt/hifiasm/hifiasm/hifiasm \
	-o ${base} \
	-t $SLURM_NPROCS \
	$svalue \
	$hom_cov \
	$ul_list \
	$h1 \
	$h2 \
	$in_files

#Convert primary contigs in gfa file to fa file
for f in *.p_ctg.gfa; do
	name=`echo ${f%.gfa}`
	/project/forage_turf/matt.robbins/matt/gfatools/gfatools gfa2fa $f > ${name}.fa
done

date
# Script is above that produced the output below
###################################################################################
