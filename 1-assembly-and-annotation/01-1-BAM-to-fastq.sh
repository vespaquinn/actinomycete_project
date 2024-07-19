#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=03:00:00
#SBATCH --job-name=bam-to-fastq
#SBATCH --output=/data/users/qcoxon/thesis/errorout/bam2fastq_%j.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/bam2fastq_%j.e
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=quinn.coxon@unifr.ch
#SBATCH --partition=pibu_el8 
#-----------------------------------
# This script runs using the sbatch --array syntax since the 
# strains are linear in their barcoding with the prefix bc20 and then numbers 33-90
# submit this script with the commandline: sbatch --array=33-90 01-1-BAM-to-fastq.sh 
#-----------------------------------
# Software used: SAMtools v. 1.13
#-----------------------------------
#-- 0 -- setup 
workdir=/data/users/qcoxon/thesis
outdir=${workdir}/data/fastq
datadir=${workdir}/data/bam_files
barcode=bc20${SLURM_ARRAY_TASK_ID}
mkdir -p ${outdir}

# load module
module load SAMtools/1.13-GCC-10.3.0

# Run SAMTools
samtools bam2fq ${datadir}/${barcode}.bam > ${outdir}/${barcode}.fastq
