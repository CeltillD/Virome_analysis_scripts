#!/usr/bin/python3

import sys 
import matplotlib.pyplot as plt
import pandas as pd
import seaborn

qfile=sys.argv[1]	#quality tsv for viruses or proviruses

Qdata=pd.read_csv(qfile,sep="\t",header=None)

outname=str(qfile.split("_")[0].replace("tmp/",""))+"_quality_plot.svg"

Lorder=["Complete","High-quality","Medium-quality","Low-quality","Not-determined"]
Lcolor=["#07ce04","#8ffa37","#fffb00","#ff8513","#d4d4d4"]

seaborn.set_style("whitegrid")
plt.figure(figsize=(6,6))
seaborn.countplot(x=1,data=Qdata,order=Lorder,palette=Lcolor)
plt.savefig(outname,format='svg')
