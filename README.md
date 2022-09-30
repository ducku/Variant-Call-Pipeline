# Variant-Call-Pipeline

* Intended to be used with GISAID data on the command line. 
* Sorts and Streamslines data into visualizable format
* Require bwa and samtools to be installed

# How to use the pipeline
1. Download fasta data from GISAID
2. Set paths in Variant_Call_Pipeline.sh and frequency_dataframe.sh
3. `bash Variant_Call_Pipeline.sh`
4. `bash frequency_dataframe.sh -r [region] -y [year] -m [month]`  (month optional)
5. Run R script to convert files to R dataframes
