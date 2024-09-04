# Characterizing Scaffolds



There are several tools utilized to characterize scaffolds

* Blobtools - identify contaminants scaffolds unsupported by reads
	* diamond blastx to nr database
	* blastn to nt database
	* mapping original reads to scaffolds using minimap
	* BUSCO scores
* Kraken - identify contaminants
* Repeat analysis - EDTA or RepeatMasker
* blastn to plastid RefSeq - identify plastid scaffolds
* blastn to mitochondrial RefSeq - identify mitochondrial scaffolds

# Prerequisite scripts

There are a few scripts that are needed to prepare outputs from tools above to combine data into one table

## Blobtools output

To run blobtools, you will first need to run the `blobtools_prep_splits.sh` script. This will run diamond blastx, blastn, and minimap. It can also run BUSCO if it has not already been run.

The `blobtools_prep_splits.sh` script will split up the input fasta file into smaller ones based on the fasta index file (which must be present in the same directory as the fasta and have the same basename).
The script has the following required arguments:
* account : SBATCH account name
* base : basename of the run
* asm : path to the assembly fasta/fa file
* readswildcard : path to reads fasta.gz files with wildcard to select all, must be between quotes
* taxid : NCBI taxid for the species (https://www.ncbi.nlm.nih.gov/taxonomy)
* runbusco : Set to 1 if BUSCO needs to be run, otherwise use the full path to the full_table.tsv file of the BUSCO analysis
* busco_lineage : the BUSCO lineage for the species

To run the script without existing BUSCO anlysis results, use the following format
```
sbatch /path/to/blobtools_prep_splits.sh account base /path/to/asm "/path/to/reads/*.fasta.gz" ncbi_taxid 1 busco_lineage
```
Otherwise, use this
```

sbatch /path/to/blobtools_prep_splits.sh account base /path/to/asm "/path/to/reads/*.fasta.gz" ncbi_taxid /full/path/to/BUSCO/full_table.tsv busco_lineage
```
ASs part of the `blobtools_prep_splits.sh` script, a script called `run_blobtools_<base>.sh` is produced to finalize the output and run blobtools. This needs to manually be run after verifying all the output from the diamond, blastn, minimap, and busco runs.

To identify the best hit from both the nr (diamond) and nt (blastn) database for each scaffold, the `get_best_hits_blobtools.sh` script is run as part of the `blobtools_prep_splits.sh` script. verify that the best_hits output file was produced.


## EDTA or RepeatMasker output

To parse the number of bp masked from each scaffold, the `get_scaf_num_bp_masked.sh` script need to be run on either the `*.mod.EDTA.TEanno.sum` file from EDTA or the `*.detailed.tbl` file from RepeatMasker

