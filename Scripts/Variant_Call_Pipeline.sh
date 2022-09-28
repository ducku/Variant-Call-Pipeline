#!/bin/bash
#Paths - need to be defined prior to running the script
#location of the fasta files
FASTADIR=~/Variant_Call_Pipeline/fasta/
#location to put the sorted files
DESTDIR=~/Variant_Call_Pipeline/regions/
#location of BWA
BWADIR=~/.miniconda3/bin/bwa
#location of samtools
SAMTOOLSDIR=~/.miniconda3/bin/samtools
#location of bcftools
BCFTOOLSDIR=~/.miniconda3/bin/bcftools

AlignmentFasta=~/Variant_Call_Pipeline/fasta_reference_file/SARS-CoV-2.fasta


for fasta_file in "$FASTADIR"*.fasta
do
	#file name without extension
	file_name=${fasta_file##*/}
	file_name=${file_name%.fasta}

	line=$(head -n 1 "$fasta_file") 
	date=${line#*|*|}
	year=${date%-*-*}
	month=${date%-*}
	month=${month#*-}
	day=${date#*-*-}
    	#remove carriage return
	day=$(echo $day | sed -e 's/\r//g')
	#Conerned about regions with spaces in them
	region=$(cut -d / -f2 <<< $line)
	mkdir -p -v "$DESTDIR"/$region/$year/$month/$day/fasta
	mkdir -p -v "$DESTDIR"/$region/$year/$month/$day/sam
	mkdir -p -v "$DESTDIR"/$region/$year/$month/$day/bam
	mkdir -p -v "$DESTDIR"/$region/$year/$month/$day/bcf
	mkdir -p -v "$DESTDIR"/$region/$year/$month/$day/vcf_snps
	mkdir -p -v "$DESTDIR"/$region/$year/$month/$day/vcf_indels
	
	file_location="$DESTDIR"/$region/$year/$month/$day
	cp "$fasta_file" "$file_location"/fasta

	## Alignment
	$BWADIR mem -M -R \
	'@RG\tID:SampleCorona\tLB:sample_1\tPL:ILLUMINA\tPM:HISEQ\tSM:SampleCorona' \
	"$AlignmentFasta" \
	"$fasta_file" > \
	$file_location/sam/$file_name".sam"

	## SAM to BAM
	samtools view -S -b \
	$file_location/sam/$file_name".sam" > \
	$file_location/bam/$file_name".bam"

	## Samtools uses reference FASTA to detect "piles" in the alignment
	$SAMTOOLSDIR mpileup -g -f "$AlignmentFasta" $file_location/bam/$file_name".bam" > \
	$file_location/bcf/$file_name".bcf"
	
	## Bcftools extracts SNPs
	$BCFTOOLSDIR view -v snps $file_location/bcf/$file_name".bcf" > \
	$file_location/vcf_snps/$file_name"_snps.vcf"

	## Bcftools extracts indels
	$BCFTOOLSDIR view -v indels $file_location/bcf/$file_name".bcf" > \
	$file_location/vcf_indels/$file_name"_indels.vcf"

done
