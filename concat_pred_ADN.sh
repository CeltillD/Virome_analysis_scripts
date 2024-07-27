#!/bin/bash
#concat_pred_ADN.sh [ VIBout VS2out DVFout fnaOri ]
#args description :

VIBout=$1	#path to VIBRANT output repository			
VS2out=$2	#........VirSorter2...............
DVFout=$3	#........DeepVirFinder...........
fnaOri=$4	#path to fasta file (assembled)

#creation of usefuls directories
for dir in "tmp" "res" ;
do
	if [ ! -d $dir ] ;
	then
		mkdir $dir
	fi
done

#extraction of viral sequences's ids for each tool
cat $VIBout/VIBRANT_phages_*/*.phages_combined.fna | grep '>' |sed 's/>//g' |sed 's/_fragment_.*//g' |sort -u > tmp/VIBids.txt
cat $VS2out/final-viral-combined.fa |grep '>' |cut -d'|' -f1 |sed 's/>//g' |sort -u > tmp/VS2ids.txt
cat $DVFout/*.txt |awk '{if($3>=0.70&&$1!="name"){print $1}}' > tmp/DVFids.txt

#creation of a fasta containing all predicted viral sequence identifiers
for ID in $(for file in $(ls tmp/*ids.txt);do cat $file ;done |sort -u);
do
	samtools faidx $fnaOri $ID
done > tmp/pred_complete.fna
