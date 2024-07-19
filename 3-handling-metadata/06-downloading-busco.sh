#!/bin/bash
# this script downloads and organises the busco results from the cluster  

# 1- setup
# save the strain names into an array to loop through and setup outdir 
names_array=($(</home/quinn/thesis/data/names.txt))

outdir=/home/quinn/thesis/data/antismash/busco
mkdir -p ${outdir}
cd ${outdir}

# loop through strains 
for name in ${names_array[@]}; do
    # download the regions.js file
    scp qcoxon@login8.hpc.binf.unibe.ch:/data/users/qcoxon/thesis/results/11-rerunning-for-contaminated/4-BUSCO/${name}/short_summary.specific.actinobacteria_phylum_odb10.${name}.json ./${name}_busco.json
    echo "copied ${name}"
done