#!/usr/bin/python3

import sys
import matplotlib.pyplot as plt
import seaborn

ORI=sys.argv[1]  # original fasta file
VIR=sys.argv[2]  # viruses.fna (synthese_pred.sh)
PRO=sys.argv[3]  # proviruses.fna (synthese_pred.sh)

Lcolor=['#33a2ff','#c8d7f3','#00139c']
Lcount=[]

def comptage_contigs(file,lmin=3000):
    count = 0
    lc = 0                      #current length of the contig
    with open(file,'r') as f:
        for l in f:
            l=l.rstrip()
            if l.startswith('>'):
                if lc >= lmin:
                    count+=1
                lc=0
            else:
                lc+=len(l)
    return count

Lcount.append(comptage_contigs(ORI))
Lcount.append(comptage_contigs(VIR))
Lcount.append(comptage_contigs(PRO))

Lcount[0]=Lcount[0]-(Lcount[1]+Lcount[2])

Llabel=["Others_contigs\nN = "+str(Lcount[0]),"viral_contigs\nN = "+str(Lcount[1]),"provial_contigs\nN = "+str(Lcount[2])]

seaborn.set_style("whitegrid")
plt.figure(figsize=(10,10)) 
plt.pie(Lcount, labels=Llabel,autopct='%1.1f%%',colors=Lcolor)  

plt.savefig("contigs_pie.svg", format='svg')
