# Scaffolding assembly using HiC/OmniC data

Once a suitable assembly has been identified the proximity ligation reads (HiC or OmniC) can be used to scaffold the contigs.  

The steps for scaffolding included in this guide are:

1. Map the HiC/OmniC reads to the contigs with the arima mapping pipeline
2. Use [yahs](https://github.com/sanger-tol/yahs) to develop scaffolds from the `.bam` file
3. Use [juicebox](https://github.com/aidenlab/Juicebox) to visually inspect and correct scaffolds

## Step 0: Set up working directories

I usually do scaffolding in a new directory and give each step a new subdirectory
```
mkdir -p scaffold/arima_map scaffold/yahs scaffold/juicebox
```

## Step 1: Arima mapping pipeline

The script to run the arima mapping pipeline is called `arima_mapping_scaffold_cont.sh` since it uses the container we make from the Docker file included in this repo.  

I usually run this in the `arima_map` directory and I make a new directory for each assembly (usually 3 assemblies: primary (p), hap1, and hap2).  

### Inputs

The script requires the HiC/OmniC reads in two files, R1 nd R2. If there are multiple R1 and R2 files, simply concatenate them into one R1 and one R2 file.

1. The R1 HiC/OmniC file
2. The R2 HiC/OmniC file
3. The assembly (contigs) that need to be scaffolded
4. A descriptive name for the project (usually the name of the assembly)


### Usage

To run the script, go to the working directory of your choice (where the output will be created - make sure to use the real `assembly_name`) and run the script:
```
cd arima_map
mkdir <assembly_name>
cd <assembly_name>
sbatch arima_mapping_scaffold_cont.sh R1_HiC_file R2_HiC_file asm_ref project_name
```

### Output

The following directories will be created by the script:
```
logs
merged
filtered
paired
temp
deduplicated
```

There shouldn't be anything in the merged directory. Check the `stderr` and `stdout` file in the logs directory to make sure everything ran correctly. If so, there should be several files including:
```
*rep1.bam
*rep1.bam.bai
*rep1.bam.stats
metrics*
```

The `*.bam` file will be used by yahs in the next step.

## Step 2: Run yahs

Once the arima mapping pipeline is complete, the `.bam` file found in the directory `arima_map/deduplicated/` will be used by yahs for scaffolding. This is accomplished by running the `run_yahs.sh` script.

### Inputs

the `run_yahs.sh` script requires 3 inputs:

1. The project name (should be the same as input 4 of the  `arima_mapping_scaffold_cont.sh` script
2. The assembly (contigs) that need to be scaffolded. IMPORTANT: This should the path of the symbolic link created by the `arima_mapping_scaffold_cont.sh` script and should be in the `arima_map` directory. This is because the `fasta.fai` that is created by the `arima_mapping_scaffold_cont.sh` is required.
3. The path to the `.bam` file in the `arima_map/deduplicated/` directory

### Usage

To run the script, go to the working directory in the `yahs` directory (where the output will be created - make sure to use the real `assembly_name`) and run the script:
```
cd yahs
mkdir <assembly_name>
cd < assembly_name>
sbatch run_yahs.sh project_name path_to_assembly path_to_deduped_bam
```
### Output

yahs will output the scaffolded assembly as a `*scaffolds_final.fa` file. along with several intermediate files. In addition to performing the scaffolding, the `run_yahs.sh` script will output `*JBAT.assembly` and `JBAT.hic` files that will be used in Juicebox.
