#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=90G
#SBATCH --time=06:30:00
#SBATCH --job-name=kraken
#SBATCH --output=/data/users/qcoxon/thesis/errorout/kraken.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/kraken.e
#SBATCH --partition=pibu_el8 
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=quinn.coxon@unifr.ch
#------------------------------------------------------------------------------
# SCRIPT 3.2 - Assembly QC with Kraken2 (checking for contamiantion)
# version 2.1.2
# Documentation available: https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.html
#------------------------------------------------------------------------------
## To run this with sbatch for all  assemblies run an sbatch array job like so:
    # sbatch --array=0-57 03-2-kraken.sh 
#-------------------------------------------------------------------------------

# 0 --- setup 
workdir="/data/users/qcoxon/thesis"
datadir=${workdir}/results/02-assembly/fasta/smrtlink
results=${workdir}/results/03-assemblyQC
names_array=($(<${workdir}/codes/names.txt))
barcodes_array=($(<${workdir}/codes/barcodes.txt))
kraken_db=/data/databases/kraken/k2_standard

# get name and barcode from slurm task ID and set assembly
i=${SLURM_ARRAY_TASK_ID} 

name=${names_array[$i]}
barcode=${barcodes_array[$i]}

echo ${name}
assembly=${datadir}/${barcode}_assembly.fasta 

# create outdir
outdir=${results}/kraken/outputs
reportdir=${results}/kraken/results
mkdir -p ${outdir}
mkdir -p ${reportdir}

# load kraken
 module load Kraken2/2.1.2-gompi-2021a

 # run kraken 
 kraken2 --db ${kraken_db} --threads 16 --output ${outdir}/${name}_kraken_output.txt --report ${reportdir}/${name}_report.txt ${assembly}
