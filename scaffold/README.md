# Scaffolding assembly using HiC/OmniC data

Once a suitable assembly has been identified the proximity ligation reads (HiC or OmniC) can be used to scaffold the contigs.  

The steps for scaffolding included in this guide are:

1. Map the HiC/OmniC reads to the contigs with the arima mapping pipeline
2. Use [yahs](https://github.com/sanger-tol/yahs) to develop scaffolds from the `.bam` file
3. Use [juicebox](https://github.com/aidenlab/Juicebox) to visually inspect and correct scaffolds

## Step 1: Arima mapping pipeline

The script to run the arima mapping pipeline is called `arima_mapping_scaffold_cont.sh` since it uses the container we make from the Docker file included here

### Inputs

The script requires the HiC/OmniC reads in two files, R1 nd R2. If there are multiple R1 and R2 files, simply concatenate them into one R1 and one R2 file.

1. The R1 HiC/OmniC file
2. The R2 HiC/OmniC file
3. The assembly (contigs) that need to be scaffolded
4. A descriptive name for the project


### Usage

To run the script, go to the working directory of your choice (where the output will be created) and run the script:
```
arima_mapping_scaffold_cont.sh R1_HiC_file R2_HiC_file asm_ref project_name
```
