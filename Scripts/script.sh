#!/bin/bash
while getopts y:m:r: flag
do
	case "${flag}" in
		y) year=${OPTARG};;
		m) month=${OPTARG};;
		r) region=${OPTARG};;
	esac
done

if [ -z $month ]
then
	monthslist="JAN FEB MAR"
else
	monthslist=$month
fi

for m in $monthslist
do
	echo $m
done
