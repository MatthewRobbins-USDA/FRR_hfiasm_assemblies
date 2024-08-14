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

To identify the best hit from both the nr and nt databased for each scaffold, the `get_best_hits_blobtools.sh` script needs to be run on the blast output table for both analyses


## EDTA or RepeatMasker output

To parse the number of bp masked from each scaffold, the `get_scaf_num_bp_masked.sh` script need to be run on either the `*.mod.EDTA.TEanno.sum` file from EDTA or the `*.detailed.tbl` file from RepeatMasker

