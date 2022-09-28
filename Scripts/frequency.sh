#!/bin/bash
while getopts y:m:v:r:d: flag
do
	case "${flag}" in
		y) year=${OPTARG};;
		m) month=${OPTARG};;
		v) variant=${OPTARG};;
		r) region=${OPTARG};;
		d) DESTDIR=${OPTARG};;
	esac
done

#DESTDIR=~/2-Variant-Call-Pipeline/regions/$year/$month
total_files_in_month=0
Variant_Total_Occurences=0

#counts total number of files containg a variant in a month
for currdir in $DESTDIR/*
do
	total_files_in_day=$(ls "$currdir"/fasta | wc -l)
	total_files_in_month=$(($total_files_in_month + $total_files_in_day))
	variant_list=$(awk '{print $2}' $currdir/vcf_snps/* | awk 'NR > 24')
	Variant_Total_Occurences=$(($Variant_Total_Occurences + $(grep -w $variant <<< $variant_list | wc -l)))
done
echo "$variant $Variant_Total_Occurences $total_files_in_month"

