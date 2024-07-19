#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --job-name=gtftofasta
#SBATCH --output=/data/users/qcoxon/thesis/errorout/hifiasm/gfa2fasta.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/hifiasm/gfa2fasta.e
#SBATCH --partition=pibu_el8 
#---------------------------------------------------------------
# SCRIPT 2.1.2 - Convert the hifiasm gfa output to fasta 
#----------------------------------------------------------------
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/results/02-assembly/hifiasm
outdir=${workdir}/results/02-assembly/hifiasm_fasta
mkdir -p ${outdir}
# loop through using 
for ((i=33; i<=90; i++)); do
    awk '/^S/{print ">"$2;print $3}' ${datadir}/bc20${i}/bc20${i}.asm.bp.p_ctg.gfa > ${outdir}/bc20${i}.p_ctg.fa
done


