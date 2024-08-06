# Virome_Scripts_M1

This page contains some of the scripts I created as part of my M1 internship using metagenomic and metatransciptomic data for virus prediction and taxonomy analysis.
For the analysis of metagenomics data, DeepVirFinder, VIBRANT and VirSorter2 are required. For metatranscriptomics, only geNomad is required.
MMseqs taxonomy need to be installed before the usage of scripts. 

<p align="center">
  <img src="https://github.com/user-attachments/assets/9f1397e5-e8ad-4661-8f9b-ff121eda7740" />
</p>

Example of pre-commands to obtain results from viral prediction tools :
```
nohup virsorter run -w output_repository -i assembled_fasta --min-length 3000 -j $(($(nproc) / 2 )) all &				#with conda env

nohup singularity exec --bind /home ~/vibrant.sif VIBRANT_run.py -i assembled_fasta -l 3000 &				#with singularity

nohup singularity exec --bind /home ~/deepvirfinder.sif  dvf.py -i assembled_fasta -l 3000 -o output_repository &	#with singularity
```

### Metatranscriptomics part :
- <code>**concat_pred_ARN.sh**</code><sub>  ( 1 ) </sub> : script combining viral sequence predictions from geNomad to produce fasta sequences (completes)
```
concat_pred_ADN.sh <_geNomad_output_dir_> <_original_fasta_>
```

### Metagenomics part :
- <code>**concat_pred_ADN.sh**</code><sub>  ( 1 ) </sub> : script combining viral sequence predictions from DeepVirFinder, VirSorter2 and VIBRANT to produce fasta sequences (completes)
```
concat_pred_ADN.sh <_VIBRANT_outpout_dir_> <_VS2_output_dir_> <_DVF_output_dir_> <_original_fasta_>
```
----------------------------------------------------------------------------------------------------------

Next, use CheckV for obtain fastas of proviruses and viruses (and their quality) :
```
# E.G.
singularity exec --bind /home ~/checkv.sif checkv end_to_end tmp/pred_complete.fna checkV_output -t$(($(nproc) / 2 ))
```
- **creaDB_refseqv.sh**<sub> ( 0 ) </sub> : useful command for creating the RefseqViral database.
DATABASE (absolute) path : /~/taxonomy/mmseqs_vrefseq/refseq_viral

- <code>**synthese.sh**</code><sub> ( 1 ) </sub> : script applied to the fasta of previously created viruses and proviruses to extract their taxonomy using MMseqs2 taxonomy and the others scripts below.
```
synthese.sh <_checkV_output_dir_> <_original_fasta_> <_absolute_path_to_DB_> 
```
Integrated scripts :

- **reformat_taxo.py**<sub> ( 2 ) </sub> : script using output "results.tsv" of MMseqs taxonomy to give an other output TSV cleaned of the taxonomy with ids and taxonomic ranks.
  
- **contigs_plot.py**<sub> ( 2 ) </sub> : give an SVG pie plot ; proportion of viral and proviral contigs (>=3kb) in the original fasta

- **barplot_quality.py**<sub> ( 2 ) </sub> : give an SVG barplotplot decribing predicted contigs's quality (with checkV results) 

- **script_sankey.R**<sub> ( 2 ) </sub> : this script returns sankey diagrams for taxonomy using report (KRAKEN-style) and the Pavian library with R.
  ### Depandancies 
  You need to install these packages before running in your R env :
  
  - _Pavian_
  ```
  # https://github.com/fbreitwieser/pavian
  if (!require(remotes)) { install.packages("remotes") }
  remotes::install_github("fbreitwieser/pavian")
  ```
  - _Webshot_
  ```
  #https://github.com/wch/webshot
  install.packages("webshot")
  webshot::install_phantomjs()
  ```
  - _htmlwidgets_
  ```
  #https://github.com/ramnathv/htmlwidgets
  devtools::install_github('ramnathv/htmlwidgets')
  # or
  install.packages("htmlwidgets")
  ```
  Others python scripts use the following packages :
    - _seaborn_
    - _matplotlib.pyplot_
    - _pandas_
  
# Outputs 

After running concat_pred_ADN.sh and synthese.sh 

### res/ :

PLOTS :
- **contigs_pie.svg** >>> from contigs_plot.py

 <p align="left">
  <img src="https://github.com/user-attachments/assets/0f1e0adf-e932-4723-bccd-ca2911487e90" width=300 height=300/>
</p>

- **[_proviruses/viruses_]_quality_plot.svg** >>> from barplot_quality.py

 <p align="left">
  <img src="https://github.com/user-attachments/assets/a94dbeb9-a430-4fc4-8a38-fb360d675b8e" width=300 height=300/>
</p>

- **sankey_taxo_report_[ proviruses/viruses ].[ pdf/html ]** >>> from script_sankey.R                  

<p align="left">
  <img src="https://github.com/user-attachments/assets/e262447f-5e12-4dce-a730-6094a738628b"/>
</p>

Kraken reports :
- **taxo_report_[ proviruses/viruses ]** >>> from mmseqs taxonomyreport ( synthese.sh )
```
100.0000	9	0	no rank	1	root
100.0000	9	1	superkingdom	10239	  Viruses
66.6667	6	0	clade	2731341	    Duplodnaviria
66.6667	6	0	kingdom	2731360	      Heunggongvirae
66.6667	6	0	phylum	2731618	        Uroviricota
66.6667	6	2	class	2731619	          Caudoviricetes
22.2222	2	0	genus	2948764	            Immutovirus
22.2222	2	0	species	2955989	              Immutovirus immuto
22.2222	2	2	no rank	2801477	                Flavobacterium phage vB_FspM_immuto_2-6A
```

TSVs :

- **taxo_results_[ proviruses/viruses ].tsv** >>> from mmseqs createtsv ( synthese.sh )
```
VM_Fargettes_2049	1094892	species	Megavirus chiliensis	d_Viruses;-_Varidnaviria;k_Bamfordvirae;p_Nucleocytoviricota;c_Megaviricetes;o_Imitervirales;f_Mimiviridae;g_Mimivirus;-_unclassified Mimivirus;s_Megavirus chiliensis
VM_Fargettes_22544	1557033	species	Yellowstone Lake virophage 5	d_Viruses;-_Varidnaviria;k_Bamfordvirae;p_Preplasmiviricota;c_Maveriviricetes;o_Priklausovirales;f_Lavidaviridae;-_unclassified Lavidaviridae;s_Yellowstone Lake virophage 5
```

- **taxonomy_[ proviruses/viruses ].tsv** >>> from reformat_taxo.py
```
ID	Domain	Kingdom	Phylum	Class	Order	Family	Genus	Species
VM_Fargettes_2049	Viruses	Bamfordvirae	Nucleocytoviricota	Megaviricetes	Imitervirales	Mimiviridae	Mimivirus	Megavirus chiliensis
VM_Fargettes_22544	Viruses	Bamfordvirae	Preplasmiviricota	Maveriviricetes	Priklausovirales	Lavidaviridae	NA	Yellowstone Lake virophage 5
```

### tmp/ :

IDs files :  text files with ids of viral sequences predicted by each tools

- *DVFids.txt*  >>> from concat_pred_ADN.sh
- *VIBids.txt*  >>> from concat_pred_ADN.sh
- *VS2ids.txt*  >>> from concat_pred_ADN.sh

Quality files :

- *[ viruses/proviruses ]_quality.tsv*  >>> from synthese.sh
```
VM_Fargettes_10277	Not-determined
VM_Fargettes_10335	Low-quality
VM_Fargettes_10438	Medium-quality
```

FASTA :

- **pred_complete.fna** >>> from concat_pred_ADN.sh
fasta of all ids predicted (full sequence)

# Index 

Scripts indices :

( 0 ) : Non-essential
( 1 ) : Main scripts
( 2 ) : Sub-scripts
