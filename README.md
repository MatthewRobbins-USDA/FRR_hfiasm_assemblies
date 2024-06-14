# FRR_hfiasm_assemblies
Scripts and documentation to perform hifiasm assemblies on ARS HPCs

# Running de novo genome assemblies using hifiasm

## Intro

## Set up directories

In the main working directory of the project, make subdirectories that will contain the analyses:  

```
mkdir hifiasm busco quast readcov kmer
```

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

### Checking to see the hifiasm assembly finished

Check the `stderr` file from the sbatch command. It should show several histograms and not have any errors:

```
[M::ha_analyze_count] lowest: count[8] = 2764401
[M::ha_analyze_count] highest: count[24] = 210109544
[M::ha_hist_line]     2: ****************************************************** 114432889
[M::ha_hist_line]     3: ************ 26117952
[M::ha_hist_line]     4: ***** 10803886
[M::ha_hist_line]     5: *** 5748431
[M::ha_hist_line]     6: ** 3636400
[M::ha_hist_line]     7: * 2846413
[M::ha_hist_line]     8: * 2764401
[M::ha_hist_line]     9: ** 3239885
[M::ha_hist_line]    10: ** 4335080
[M::ha_hist_line]    11: *** 6488405
[M::ha_hist_line]    12: ***** 10163492
[M::ha_hist_line]    13: ******** 16142315
[M::ha_hist_line]    14: ************ 24943011
[M::ha_hist_line]    15: ****************** 37126126
[M::ha_hist_line]    16: ************************* 53187749
[M::ha_hist_line]    17: *********************************** 73008248
[M::ha_hist_line]    18: ********************************************** 95865097
[M::ha_hist_line]    19: ********************************************************* 120786379
[M::ha_hist_line]    20: ********************************************************************* 145591018
[M::ha_hist_line]    21: ******************************************************************************** 169105805
[M::ha_hist_line]    22: ****************************************************************************************** 188785140
[M::ha_hist_line]    23: ************************************************************************************************* 203060824
[M::ha_hist_line]    24: **************************************************************************************************** 210109544
[M::ha_hist_line]    25: **************************************************************************************************** 209875490
[M::ha_hist_line]    26: ************************************************************************************************* 202761574
[M::ha_hist_line]    27: ****************************************************************************************** 189583483
[M::ha_hist_line]    28: ********************************************************************************** 171724976
[M::ha_hist_line]    29: ************************************************************************ 151076109
[M::ha_hist_line]    30: ************************************************************** 129274018
[M::ha_hist_line]    31: *************************************************** 108130652
[M::ha_hist_line]    32: ****************************************** 88370996
[M::ha_hist_line]    33: ********************************** 71308237
[M::ha_hist_line]    34: *************************** 57349955
[M::ha_hist_line]    35: ********************** 46530917
[M::ha_hist_line]    36: ******************* 38919214
[M::ha_hist_line]    37: **************** 34250627
[M::ha_hist_line]    38: *************** 31981290
[M::ha_hist_line]    39: *************** 31786647
[M::ha_hist_line]    40: **************** 33232515
[M::ha_hist_line]    41: ***************** 35928737
[M::ha_hist_line]    42: ******************* 39546871
[M::ha_hist_line]    43: ********************* 43645783
[M::ha_hist_line]    44: *********************** 47956887
[M::ha_hist_line]    45: ************************* 52294988
[M::ha_hist_line]    46: *************************** 56034644
[M::ha_hist_line]    47: **************************** 59302168
[M::ha_hist_line]    48: ***************************** 61768881
[M::ha_hist_line]    49: ****************************** 63089108
[M::ha_hist_line]    50: ****************************** 63657122
[M::ha_hist_line]    51: ****************************** 63167913
[M::ha_hist_line]    52: ***************************** 61754752
[M::ha_hist_line]    53: **************************** 59490055
[M::ha_hist_line]    54: *************************** 56340970
[M::ha_hist_line]    55: ************************* 52642322
[M::ha_hist_line]    56: *********************** 48528852
[M::ha_hist_line]    57: ********************* 44167227
[M::ha_hist_line]    58: ******************* 39728434
[M::ha_hist_line]    59: ***************** 35356108
[M::ha_hist_line]    60: *************** 31171656
[M::ha_hist_line]    61: ************* 27233206
[M::ha_hist_line]    62: *********** 23656275
[M::ha_hist_line]    63: ********** 20436563
[M::ha_hist_line]    64: ******** 17726952
[M::ha_hist_line]    65: ******* 15346592
[M::ha_hist_line]    66: ****** 13381943
[M::ha_hist_line]    67: ****** 11809270
[M::ha_hist_line]    68: ***** 10607298
[M::ha_hist_line]    69: ***** 9671135
[M::ha_hist_line]    70: **** 8924025
[M::ha_hist_line]    71: **** 8371005
[M::ha_hist_line]    72: **** 7987607
[M::ha_hist_line]    73: **** 7718882
[M::ha_hist_line]    74: **** 7484402
[M::ha_hist_line]    75: *** 7295164
[M::ha_hist_line]    76: *** 7107802
[M::ha_hist_line]    77: *** 6912984
[M::ha_hist_line]    78: *** 6725701
[M::ha_hist_line]    79: *** 6498764
[M::ha_hist_line]    80: *** 6272204
[M::ha_hist_line]    81: *** 6073149
[M::ha_hist_line]    82: *** 5843171
[M::ha_hist_line]    83: *** 5595001
[M::ha_hist_line]    84: *** 5350186
[M::ha_hist_line]    85: ** 5138794
[M::ha_hist_line]    86: ** 4912266
[M::ha_hist_line]    87: ** 4690619
[M::ha_hist_line]    88: ** 4498430
[M::ha_hist_line]    89: ** 4328023
[M::ha_hist_line]    90: ** 4191671
[M::ha_hist_line]    91: ** 4069721
[M::ha_hist_line]    92: ** 3966315
[M::ha_hist_line]    93: ** 3880703
[M::ha_hist_line]    94: ** 3814633
[M::ha_hist_line]    95: ** 3765852
[M::ha_hist_line]    96: ** 3737267
[M::ha_hist_line]    97: ** 3692339
[M::ha_hist_line]    98: ** 3665825
[M::ha_hist_line]    99: ** 3657228
[M::ha_hist_line]   100: ** 3624175
[M::ha_hist_line]   101: ** 3586786
[M::ha_hist_line]   102: ** 3541305
[M::ha_hist_line]   103: ** 3460730
[M::ha_hist_line]   104: ** 3400834
[M::ha_hist_line]   105: ** 3349871
[M::ha_hist_line]   106: ** 3259942
[M::ha_hist_line]   107: ** 3191560
```

Also, there should be several files in the basename directory, including 3 large files that end in `*.fa`:
```
ll -t tall_fescue_13cells_hic
total 346402470
-rw-r--r--. 1 matthew.robbins proj-forage_turf   7711213513 Mar 29 17:22 tall_fescue_13cells_hic.hic.p_ctg.fa
-rw-r--r--. 1 matthew.robbins proj-forage_turf   7230490660 Mar 29 17:20 tall_fescue_13cells_hic.hic.hap2.p_ctg.fa
-rw-r--r--. 1 matthew.robbins proj-forage_turf   7324546203 Mar 29 17:19 tall_fescue_13cells_hic.hic.hap1.p_ctg.fa
-rw-r--r--. 1 matthew.robbins proj-forage_turf      1205992 Mar 29 17:15 tall_fescue_13cells_hic.hic.hap2.p_ctg.lowQ.bed
-rw-r--r--. 1 matthew.robbins proj-forage_turf    180856995 Mar 29 17:14 tall_fescue_13cells_hic.hic.hap2.p_ctg.noseq.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf   7292803501 Mar 29 17:14 tall_fescue_13cells_hic.hic.hap2.p_ctg.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf      1932170 Mar 29 17:13 tall_fescue_13cells_hic.hic.hap1.p_ctg.lowQ.bed
-rw-r--r--. 1 matthew.robbins proj-forage_turf    183096341 Mar 29 17:12 tall_fescue_13cells_hic.hic.hap1.p_ctg.noseq.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf   7387540871 Mar 29 17:12 tall_fescue_13cells_hic.hic.hap1.p_ctg.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf   8398796240 Mar 29 07:22 tall_fescue_13cells_hic.hic.lk.bin
-rw-r--r--. 1 matthew.robbins proj-forage_turf 133503708032 Mar 29 06:25 tall_fescue_13cells_hic.hic.tlb.bin
-rw-r--r--. 1 matthew.robbins proj-forage_turf      2011332 Mar 29 04:18 tall_fescue_13cells_hic.hic.p_ctg.lowQ.bed
-rw-r--r--. 1 matthew.robbins proj-forage_turf    191180292 Mar 29 04:17 tall_fescue_13cells_hic.hic.p_ctg.noseq.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf   7775952512 Mar 29 04:17 tall_fescue_13cells_hic.hic.p_ctg.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf      4057879 Mar 29 01:38 tall_fescue_13cells_hic.hic.p_utg.lowQ.bed
-rw-r--r--. 1 matthew.robbins proj-forage_turf    358717155 Mar 29 01:36 tall_fescue_13cells_hic.hic.p_utg.noseq.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf  14862750657 Mar 29 01:36 tall_fescue_13cells_hic.hic.p_utg.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf      4543425 Mar 29 01:34 tall_fescue_13cells_hic.hic.r_utg.lowQ.bed
-rw-r--r--. 1 matthew.robbins proj-forage_turf    359136764 Mar 29 01:31 tall_fescue_13cells_hic.hic.r_utg.noseq.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf  15217790599 Mar 29 01:31 tall_fescue_13cells_hic.hic.r_utg.gfa
-rw-r--r--. 1 matthew.robbins proj-forage_turf  49651380398 Mar 29 00:28 tall_fescue_13cells_hic.ovlp.reverse.bin
-rw-r--r--. 1 matthew.robbins proj-forage_turf  80820283352 Mar 29 00:22 tall_fescue_13cells_hic.ovlp.source.bin
-rw-r--r--. 1 matthew.robbins proj-forage_turf 113469699155 Mar 29 00:13 tall_fescue_13cells_hic.ec.bin
```

## Running tools to QC assemblies

### Software used to QC assemblies

There are several software tools that provide data on the quality of an assembly. Major qualtiy considerations are:  

* Contiguity
* Completeness
* Correctness

* BUSCO
    * website
    * Identifies how many single-copy orthologous genes are found in our assembly
    * Helps determine completeness
* QUAST
    * website
    * Provides general assembly metrics
    * Helps determine contiguity
*  Mapping original reads to the assembly (read coverage or readcov)
    * Custom scripts to get readcov
    * Helps determine correctness

## Running Busco

Multiple busco analyses can be run in parallel using the `run_multiple_buscos.sh` script

### Required inputs

* path to the working directory where busco will find the inputs and save the output
* a file of file names (fofn) of all the files that will be analyzed by busco
* the name of a busco lineage
* the mode that busco will run. This is either genome, transcriptome, or proteins

#### working directory

This should be the `busco` directory made above. The full path needs to be provided.

#### file of file names (fofn)
Hifiasm will output three contig assemblies:  

* basename.p_ctg.fa
* basename.hap1.p_ctg.fa
* basenmae.hap2.p_ctg.fa


The script `run_multiple_buscos.sh` will run busco on all three of these `*.fasta` files, but a fofn needs to be created with one file per line (with full path). This is best created in a `run` directory that will contain the logs of the script.

```
mkdir run
realpath path/to/hifiasm/*.fa > run/<name>.fofn
```
#### Busco lineage

Busco also needs to use a set of orthologous genes that will be automatically downloaded or the location of a local copy specified. The local of local lineages can be changed by changing the `locallinpath` variable

```
#Loal path to already downloaded busco lineages
locallinpath=/project/forage_turf/matt.robbins/matt/busco/lineages
```

For almost all species we work with at FRR, the lineage will be poales_odb10.  

#### Buco mode

Busco can be run in 3 modes:  

* genome
* proteins
* transcriptome

The mode depends upon the input. For our genome assemblies it will always be `genome` mode.


### Running the script

The `run_multiple_buscos.sh` script should be invoked in the `busco` working directory created in the "Set up directories" section above. Logs will be saved in the `run/logs` directory.  

**IMPORTANT NOTE:** This script is not meant to be run using sbatch. It will create new scripts and run each using sbatch.  

```
path/to/run_multiple_buscos.sh `realpath .` run/<name>.fofn poales_odb10 genome
```

### Verifying Busco ran correctly


## Running Quast

Assembly metrics are calculated by quast using the `run_quast_fofn.sh` script

### Required inputs

* path to the working directory where quast will save the output
* basename. This is usually the same as the first input when running hifiasm
* a file of file names (fofn) of all the files that will be analyzed by quast

#### working directory

This should be the `quast` directory made above. The full path needs to be provided.

#### basename

This is usually the same as the first input when running hifiasm.

#### file of file names (fofn)

This is usually the same fofn used in the `run_multiple_buscos.sh` script invoked in the running Busco section.

### Running the script

The `run_quaste_fofn.sh` script should be run in the `quast` working directory created in the "Set up directories" section above. Logs will be saved in the `logs` directory.  

```
sbatch /path/to/run_quast_fofn.sh `realpath .` <basename> ../busco/run/<name>.fofn
```

## Getting read coverage of each assembly

Read covergae (readcov) of each assembly is obtained using the `get_read_covs.sh` script where the original reads are mapped to the assembly and samtools and bedtools are used to calculate the coverage of the reads across the assembly in 10kb windows.  

The `get_read_covs.sh` script needs to be run separately for each of the three hifiasm contig assemblies (see notes in Running Busco section above).

### Required inputs

* basename. This is usually the same as the first input when running hifiasm
* The assembly file (full path)
* A fofn of the path to the original reads files (one per line)
* The minimap preset

#### basename

This is usually the same as the first input when running hifiasm

#### The assembly file

This is one of the 3 contig assemblies output from running hifiasm above. The `get_read_covs.sh` script needs to be run for each of the assemblies

#### orginial reads fofn

**THIS IS NOT THE SAME FOFN** as used for Busco and quast above. This is a fofn of the original reads used in the hifiasm assembly and can usually be created in a run directory with the following command:  

```
ls </path/to/original/reads/files> > run/hifi_reads.fofn
#EXAMPLE:
ls /90daydata/arsturf/matt.robbins/poa_arachnifera/genomic_ccs/*.fasta.gz > run/hifi_reads.fofn
```

When used in the script, it should be the absolute path of the fofn.

#### the minimap preset

This is an important parameter for minimap to know what kind of reads will be mapped to the assembly. This could be several values:  

* map-hifi
* map-pb
* map-ont
* sr

In our case (a hifiasm assembly on PacBio hifi reads) this will be `map-hifi`.  

### Running the script

The `get_read_covs.sh` script should be run in the `readcov` working directory created in the "Set up directories" section above. Logs will be saved in the `logs` directory.
 
```
sbatch /path/to/get_read_covs.sh <basename> /path/to/hifiasm/contig/assembly `realpath run/hifi_reads.fofn` map-hifi
```
