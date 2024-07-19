#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=90G
#SBATCH --time=06:00:00
#SBATCH --job-name=busco
#SBATCH --output=/data/users/qcoxon/thesis/errorout/BUSCO_%j.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/busco_%j.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# SCRIPT 4.3 Check Annotations with BUSCO
# version 5.4.2
# Documentation Available: https://busco.ezlab.org/busco_userguide.html
#--------------------------------------------------------------
## To run this with sbatch for all  assemblies run an sbatch array job like so:
    # sbatch --array=0-55 04-3-BUSCO.sh 
#--------------------------------------------------------------
#Setup names 
names_array=($(</data/users/qcoxon/thesis/codes/final_names.txt))
i=${SLURM_ARRAY_TASK_ID} 
name=${names_array[$i]}

#Setup directories
workdir=/data/users/qcoxon/thesis
tempdir=${workdir}/temp
datadir=${workdir}/results/02-assembly/final_renamed
outdir=${workdir}/results/04-annotation/busco
mkdir -p ${outdir}
cd ${outdir}
assembly=${datadir}/${name}_assembly.fasta
#mkdir -p ${outdir}


# Create 'cleaned up' fasta for busco that uses _ instead of / (as / causes fatal BUSCO error)
cp ${assembly} ${tempdir}
sed -i 's/\//_/g' ${tempdir}/${name}_assembly.fasta

assembly_cleaned=${tempdir}/${name}_assembly.fasta
echo ${name}

#Load module
module load BUSCO/5.4.2-foss-2021a

#Run BUSCO
busco -i ${assembly_cleaned} -m genome -l actinobacteria_phylum_odb10 -o ${name} -c 8 -f
    # -i input file (assembky)
    # -m mode (genome,transcriptome,protein)
    # -l lineage (available lineages can be found with busco --list-datasets)
    # -o output name (NB. NOT output directory) 
    # -c cpu number (number of threads)
    # -f force - overwrite existing data if present 

#Remove the temporary assembly file 
rm ${assembly_cleaned}