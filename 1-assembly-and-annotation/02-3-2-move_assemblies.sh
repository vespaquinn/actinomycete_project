#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --job-name=move_asm
#SBATCH --output=/data/users/qcoxon/thesis/move_asm.o
#SBATCH --error=/data/users/qcoxon/thesis/move_asm.e
#SBATCH --partition=pibu_el8 
#---------------------------------------------------------------
# Move the smrtlink assemblies into a more appropriate directory 
#---------------------------------------------------------------
outdir=/data/users/qcoxon/thesis/results/02-assembly/smrtlink_fasta
mkdir -p ${outdir}

for ((i=33; i<=90; i++)); do
    cp /data/users/qcoxon/thesis/results/02-assembly/smrtlink/bc20${i}/cromwell_out/outputs/final_assembly.fasta ${outdir}/bc20${i}_assembly.fasta

done

