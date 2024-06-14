#!/bin/bash

#The directory where all the output will go
busco_work_dir=$1
#The file that contains a list of all the assemblies on which to run busco - FULL PATH NAMES
#This file is usually in the ./run directory
asm_fofn=$2
lineage=$3
#This must be a lineage in /project/forage_turf/matt.robbins/matt/busco/lineages
mode=$4 #this MUST BE either genome, proteins, or transcriptome

#Loal path to already downloaded busco lineages 
locallinpath=/project/forage_turf/matt.robbins/matt/busco/lineages

while read line; do
	name=`basename $line`
	asmdir=`dirname $line`
	echo $name
	sbatch_cmds="#!/bin/bash
#SBATCH -A forage_turf
#SBATCH --job-name=\"busco_${name}_${lineage}\"
#SBATCH -q frr
#SBATCH -p priority
#SBATCH -N 1
#SBATCH -n 72
#SBATCH -t 2-00:00:00
#SBATCH --mail-user=matthew.robbins@usda.gov
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH -o \"run/logs/stdout.%x.%j.%N\"
#SBATCH -e \"run/logs/stderr.%x.%j.%N\"

cat \`echo \$0\`
date

cd $busco_work_dir 
module purge
module load apptainer/1.2.2
	"
	bash_cmds="
singularity exec --cleanenv \\
	-B ${asmdir}:/asmloc \\
	-B $locallinpath:/lineages \\
	/project/forage_turf/matt.robbins/matt/singularity/busco_v5.4.7_cv1.sif busco \\
	-i /asmloc/${name} \\
	-o ${name}_busco_${lineage} \\
	-l /lineages/${lineage} \\
	-m $mode \\
	--download_path \$TMPDIR \\
	--offline \\
	-c \$SLURM_NPROCS
date
	"
	echo "$sbatch_cmds" > run/run_busco_${name}_${lineage}.sh
	echo "$bash_cmds" >> run/run_busco_${name}_${lineage}.sh
	sbatch run/run_busco_${name}_${lineage}.sh
done < $asm_fofn
