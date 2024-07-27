#!/bin/bash
#concat_pred_ARN.sh [ GNOout fnaOri ]

GNOout=$1	#path to geNomad output repository
fnaOri=$2	#path to fasta file (assembled)

#creation of usefuls directories
for dir in "tmp" "res" ;
do
	if [ ! -d $dir ] ;
	then
		mkdir $dir
	fi
done

PRO=$GNOout/*find_proviruses/*provirus.fna 
VIR=$GNOout/*summary/*virus.fna

#creation of a fasta containing all predicted viral sequence identifiers
for file in $VIR $PRO;
do
	for id in $(cat $file |grep '>' |sed 's/>//g');
	do
		samtools faidx $fnaOri $id
	done
done > tmp/pred_complete.fna

cat tmp/pred_complete.fna |grep '>' |sed 's/>//g' > tmp/GNOids.txt
