#!/bin/bash
#SBATCH --cpus-per-task=24
#SBATCH --mem=90G
#SBATCH --time=1-12:00:00
#SBATCH --job-name=34-90smrtlink_test
#SBATCH --output=/data/users/qcoxon/thesis/errorout/smrtlink/_smrtlink3_%j.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/smrtlink/smrtlink3_%j.e
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=quinn.coxon@unifr.ch
#SBATCH --partition=pibu_el8 
#---------------------------------------------------------------
# SCRIPT 2.3 - Assembly with SMRTLink
# version 13
# Documentation available: https://www.pacb.com/wp-content/uploads/SMRT-Link-User-Guide-v13.0.pdf
#----------------------------------------------------------------
# This script runs using the sbatch --array syntax since the 
# strains are linear in their barcoding with the prefix bc20 and then numbers 33-90
# submit this script with the commandline: sbatch --array=33-90 02-3-smrtlink.sh 

#-- 0 -- setup 
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/data/bam_files
barcode=bc20${SLURM_ARRAY_TASK_ID}
outdir=${workdir}/results/02-assembly/other/smrtlink/${barcode}
rm -r ${outdir}
mkdir -p ${outdir}
cd ${outdir}

# export paths 
export SMRT_ROOT="${workdir}/software/smrtlink13"
export TMPDIR="${workdir}/temp"

#build subreadset
$SMRT_ROOT/smrtcmds/bin/dataset create --type ConsensusReadSet --name ${barcode} ${barcode}.subreadset.xml ${datadir}/${barcode}.bam

#build assembly and methylations
$SMRT_ROOT/smrtcmds/bin/pbcromwell run pb_microbial_analysis -e ${barcode}.subreadset.xml --task-option tmp_dir=${workdir}/temp --overwrite
