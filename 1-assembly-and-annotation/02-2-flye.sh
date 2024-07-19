#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=256G
#SBATCH --time=1-12:00:00
#SBATCH --job-name=flye-run
#SBATCH --output=/data/users/qcoxon/thesis/errorout/flye.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/flye.e
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=quinn.coxon@unifr.ch
#SBATCH --partition=pibu_el8 
#---------------------------------------------------------------
# SCRIPT 2 - Assembly with flye
# version 2.9
# Documentation available: https://github.com/mikolmogorov/Flye/blob/flye/docs/USAGE.md
#----------------------------------------------------------------
# This script runs using the sbatch --array syntax (thanks Laurent) since the 
# strains are linear in their barcoding with the prefix bc20 and then numbers 33-90
# submit this script with the commandline: sbatch --array=33-90 02-2-flye.sh 

#-- 0 -- setup 
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/data/fastq
barcode=bc20${SLURM_ARRAY_TASK_ID}
outdir=${workdir}/results/02-assembly/flye/${barcode}
mkdir -p ${outdir}

# load module
module load Flye/2.9-GCC-10.3.0

flye ${datadir}/${barcode}.fastq.gz -o ${outdir} -t 16
