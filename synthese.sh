#!/bin/bash

CheckVout=$1	#path to checkV output repository 
fnaOri=$2	#original fasta file (assembled)
DB=$3		#path to database

loc=$(dirname $(readlink -f $0))	#directory of the main file

for dir in "tmp" "res" ;
do
	if [ ! -d $dir ] ;
	then
		mkdir $dir
	fi
done

for frac in "viruses" "proviruses";
do
	if [ ! -d $frac ];
	then
		mkdir $frac
	fi
	if [ $frac == "viruses" ];
	then
		for v in $(grep '>' $CheckVout/$frac.fna |sed 's/>//g');
		do
			grep -w $v $CheckVout/quality_summary.tsv |awk 'BEGIN{OFS="\t"}{print $1,$8}'	#production of a quality tsv for viruses
		done | sort -u > tmp/$frac\_quality.tsv
	else
		cat $CheckVout/quality_summary.tsv |awk 'BEGIN{OFS="\t"}{if($3=="Yes"){print $1,$8}}' |sort -u > tmp/$frac\_quality.tsv 
		#production of a quality tsv for proviruses
	fi
	mv $CheckVout/$frac.fna $frac/.
  cd $frac
	mmseqs createdb *.fna query
  mmseqs taxonomy query $DB res tmp --tax-lineage 1 --lca-mode 3
	#--tax-lineage for all taxonomy ranks (D,K...G,S)
	#--lca-mode 3 [LCA default mode]
  mmseqs createtsv query res taxo_results_$frac.tsv 
  mmseqs taxonomyreport $DB res taxo_report_$frac 
	mv taxo_results_$frac.tsv ../res/. 
  mv taxo_report_$frac ../res/. 
  mv $frac.fna ../$CheckVout/. 
  cd .. 
  rm -r $frac/
	#create a TSV with all taxonomics ranks for each id
	if [[ -e $loc/reformat_taxo.py ]];
	then
		python3 "$loc/reformat_taxo.py" res/taxo_results_$frac.tsv > res/taxonomy_$frac.tsv
	fi
done

#pie plot for contigs percentages
if [[ -e $loc/contigs_plot.py ]];	
then
	python3 "$loc/contigs_plot.py" $fnaOri $CheckVout/viruses.fna $CheckVout/proviruses.fna
	mv *.svg res/.
fi

#executing sankey's diagrams script with : taxo_report_virus and taxo_report_provirus ( KRAKEN-style )
if [[ -e $loc/script_sankey.R ]];
then
	for report in $(ls res/taxo_report*viruses);
	do
		mv $report .
		R --vanilla < "$loc/script_sankey.R" $(basename $report)
		mv $(basename $report) res/.
	done
	mv sankey* res/.
fi

#barplot quality for viruses and proviruses
if [[ -e $loc/barplot_quality.py ]];
then
	for qfile in $(ls tmp/*viruses_quality.tsv);
	do 
	python3 $loc/barplot_quality.py $qfile
	done
	mv *.svg res/.
fi
