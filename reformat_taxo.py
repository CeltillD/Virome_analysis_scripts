#!/usr/bin/python3

import sys

input_taxo=sys.argv[1]	#output results.tsv of MMseqs taxonomy

Dtaxo={}

with open(input_taxo,'r') as f :
	for l in f :
		Dline={'d':'NA','k':'NA','p':'NA','c':'NA','o':'NA','f':'NA','g':'NA','s':'NA'}
		l=l.rstrip().split("\t")
		for r in (l[-1].split(";")):
			if r[0] in ['d','k','p','c','o','f','g','s'] :	#attribution of taxonomic ranks for each ids
				Dline[r[0]]=r[2:]
		Dtaxo[l[0]]=Dline

print("ID","Domain","Kingdom","Phylum","Class","Order","Family","Genus","Species",sep="\t")
for i,j in Dtaxo.items():
	print(i,end="")
	for r in j.keys():
		print("\t",j[r],sep="",end="")
	print()

#output type TSV :	
#ID	Domain	Kingdom	Phylum	Class	Order	Family	Genus	Species
#Virus2901_51969	Viruses	Heunggongvirae	Uroviricota	Caudoviricetes	NA	NA	Immutovirus	Immutovirus immuto
#Virus2901_85816	Viruses	Heunggongvirae	Uroviricota	Caudoviricetes	NA	NA	Teubervirus	NA
#Virus2901_107746	Viruses	Heunggongvirae	Uroviricota	Caudoviricetes	NA	NA	NA	NA
