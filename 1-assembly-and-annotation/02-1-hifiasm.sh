#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --mem=256G
#SBATCH --time=1-12:00:00
#SBATCH --job-name=34-90hifiasm_test
#SBATCH --output=/data/users/qcoxon/thesis/errorout/hifiasm/hifi_loop_%j.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/hifiasm/hifi_loop_%j.e
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=quinn.coxon@unifr.ch
#SBATCH --partition=pibu_el8 
#---------------------------------------------------------------
# SCRIPT 2.1 - Assembly with hifiasm
# version 0.16.1
# Documentation available: https://github.com/chhylp123/hifiasm
#----------------------------------------------------------------
# This script runs using the sbatch --array syntax since the 
# strains are linear in their barcoding with the prefix bc20 and then numbers 33-90
# submit this script with the commandline: sbatch --array=33-90 02-1-hifiasm.sh 

#-- 0 -- setup 
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/data/fastq
barcode=bc20${SLURM_ARRAY_TASK_ID}
outdir=${workdir}/results/02-assembly/hifiasm/${barcode}
mkdir -p ${outdir}

# load module
module load hifiasm/0.16.1-GCCcore-10.3.0

hifiasm -o ${outdir}/${barcode}.asm -t 48 ${datadir}/${barcode}.fastq.gz

