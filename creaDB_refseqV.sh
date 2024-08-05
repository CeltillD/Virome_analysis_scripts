#!/bin/bash
#based on : https://github.com/deng-lab/viroprofiler/blob/main/modules/local/setup_db.nf
#init of refseq DB
if [ ! -d taxonomy ];
then
	mkdir taxonomy;
fi

if [ ! -d taxonomy/taxdump ];
then
	mkdir dl_taxdump
	mkdir taxonomy/taxdump
	cd dl_taxdump
	wget -O taxdump.zip https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump_archive/taxdmp_2022-08-01.zip
	unzip taxdump.zip
	mv names.dmp nodes.dmp delnodes.dmp merged.dmp ../taxonomy/taxdump
	cd ..
	rm -r dl_taxdump
fi

if [ ! -d taxonomy/mmseqs_vrefseq ]; 
then
	mkdir taxonomy/mmseqs_vrefseq
	wget -O taxonomy/mmseqs_vrefseq.tar.gz "https://zenodo.org/record/7044674/files/mmseqs_vrefseq.tar.gz"
	tar -zxvf taxonomy/mmseqs_vrefseq.tar.gz -C taxonomy
	rm taxonomy/mmseqs_vrefseq.tar.gz
	cd taxonomy/mmseqs_vrefseq
	mmseqs createdb refseq_viral.faa refseq_viral
	mmseqs createtaxdb refseq_viral tmp --ncbi-tax-dump ../taxdump --tax-mapping-file virus.accession2taxid
	mmseqs createindex refseq_viral tmp
	rm -rf tmp mmseqs_vrefseq.tar.gz
	cd ../..
fi
