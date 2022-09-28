#!/bin/bash
while getopts y:m:r: flag
do
	case "${flag}" in
		y) year=${OPTARG};;
		m) month=${OPTARG};;
		r) region=${OPTARG};;
	esac
done

INPUTDIR=~/Variant_Call_Pipeline/regions/$region/$year
OUTPUTDIR=~/Variant_Call_Pipeline/dataframes
SCRIPTDIR=~/Variant_Call_Pipeline/Scripts


if [ -z $month ]
then
	monthslist="01 02 03 04 05 06 07 08 09 10 11 12"
else
	monthslist=$month
fi

#for each month
for currmonth in $monthslist
do
	col=""
	#for each day
	for currdir in $INPUTDIR/$currmonth/*
	do
		#echo $currdir
		#for each vcf file
		for vcf_file in $currdir/vcf_snps/*.vcf
		do

			#not 100% sure if removing first 24 rows is correct. Tested on a few vcf files and it seems to be the case that the data start after the 24th line
			col+=$(awk '{print $2}' $vcf_file | awk 'NR > 24')
			col+=" "
		#for each variant
	
		done	
	
	done


	#remove all duplicates
	declare -A uniq
	for k in $col
	do
		uniq[$k]=1
	done
	echo ${!uniq[@]} | wc

	#remove file if it exists
	rm $OUTPUTDIR/$region"_"$year"_"$currmonth"_df.csv"

	for variant in ${!uniq[@]}
	do
		#echo $variant
		bash $SCRIPTDIR/frequency.sh -y $year -m $currmonth -v $variant -r $region -d $INPUTDIR/$currmonth >> $OUTPUTDIR/$region"_"$year"_"$currmonth"_df.csv"	

	done
	unset uniq
done
