# FRR_hfiasm_assemblies
Scripts and documentation to perform hifiasm assemblies on ARS HPCs

# Running de novo genome assemblies using hifiasm

## Intro


## Assemblies with hifiasm

### Types of assemblies

##### HiFi-only (or basic) assembly:
This is an assembly with only hifi reads.  
This is run using the `run_hifiasm.sh` script, with no additional flags.

##### HiC integrated assembly: 
This is an assembly with hifi reads and HiC (or OmniC or other proximity ligation) reads.  
This is run using the `run_hifiasm.sh` script with the -1 and -2 flags

##### Telomere-to-telomere (T2T) assembly: 
This is an assembly with hifi reads, HiC reads, and ultralong ONT reads.  
This is run using the `run_hifiasm.sh` script with the -1, -2, and -u flags.

### Required Inputs

| Order | Name                                | basic     | HiC | T2T |
|-------|-------------------------------------|-----------|-----|-----|
| 1     | Name of the assembly (base name)    | X         | X   | X   |
| 2     | files containing PacBio hifi reads  | X         | X   | X   |
| 3     | The R1 file containing R1 HiC reads |           | X   | X   |
| 4     | The R2 file containing R2 HiC reads |           | X   | X   |
| 5     | Comma separated file list containing ONT long reads      |           |     | X   |

*Name:* The name of the assembly usually contains the species, hifiasmv__, the number of PacBio SMRT cells used as input, and the assembly type (e.g. basic, hic, etc).  
e.g. `tall_fescue_hifiasmv19_13cells_hic`  

*PacBio hifi reads:* The PacBio hifi reads are usually transferred from our local servers to a suitable location on the HPC.

*HiC reads:* The HiC reads are usually transferred from our local servers to a suitable location on the HPC.
If there are multiple R1 and R2 files, they must be concatenated into one file before used in hifiasm e.g.:
```
cat tall_fescue*R1.fastq.gz > tallfescue_all_R1.fastq.gz
cat tall_fescue*R2.fastq.gz > tallfescue_all_R2.fastq.gz
```
Then the `tallfescue_all_R1.fastq` and `tall_fescue_all_R2.fastq` files are used as inputs for flags -1 and -2, respectively.

*ONT long reads:* The ONT long reads are usually transferred from our local servers to a suitable location on the HPC. These files can be used with the -u flag.

### Optional Inputs

There are two optional flags that can be used when running the `run_hifiasm.sh` script. These are the -s and -H flags. The -s flag allows you to specify a different s value. The -H flag allows you to specify a different homozygous read coverage value. If used, these flags should come before any required arguments.

### Running the scripts

**_IMPORTANT NOTE:_** The path to the PacBio hifi files can include wildcards like `*.fasta.gz` BUT IT MUST BE WITHIN DOUBLE QUOTES if used as an argument in the sbatch command.  
e.g. `"/90daydata/arsturf/matt.robbins/poa_arachnifera/genomic_ccs/*.fasta.gz"` otherwise only the first file will be used.  
Additionally, when specifying ONT files for T2T, you have to use a comma separated list (no whitespace) with the full paths to each file. It's recommended to put this within double quotes, like so: `"/path/to/ont1,/path/to/ont2,/path/to/ont3"`

Make sure to be in the hifiasm subdirectory  
```
cd hifiasm
```

##### Basic:
```
sbatch /path/to/run_hifiasm.sh <basename> </path/to/hifi_files>
```

##### HiC:

```
sbatch /path/to/run_hifiasm.sh -1 </path/to/R1_file> -2 </path/to/R2_file> <basename> </path/to/hifi_files>
```

#### T2T
```
sbatch /path/to/run_hifiasm.sh -1 </path/to/R1_file> -2 </path/to/R2_file> -u <list,of,ont,files> <basename> </path/to/hifi_files>
```

