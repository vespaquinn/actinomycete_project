#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/qcoxon/thesis/errorout/fastqc.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/fastqc.e
#SBATCH --partition=pibu_el8
#---------------------------------------------------------------
# SCRIPT 1.2 - Quality control of the Assemblies
# Run fastQC on the fastq files generated from bam files for all reads 
# using fastqc v. 0.11.9
#----------------------------------------------------------------
#-- 0 -- setup 
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/data/fastq
outdir=${workdir}/results/01-QC
datasets=($(<barcodes.txt))

mkdir -p ${outdir}

# load module
module load UHTS/Quality_control/fastqc/0.11.9

for dataset in "${datasets[@]}"; do
    fastqc -t 8 ${datadir}/${dataset}.fastq.gz -o ${outdir}
done
