#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=90G
#SBATCH --time=00:30:00
#SBATCH --job-name=prokka-test
#SBATCH --output=/data/users/qcoxon/thesis/errorout/PROKKA_%j.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/prokka_%j.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# SCRIPT 4.1 Annotate with Prokka.
# version 1.14.5 
# Documentation Available: https://github.com/tseemann/prokka
# (Test case took 4.08 minutes with 8 threads.)
#--------------------------------------------------------------
## To run this with sbatch for all  assemblies run an sbatch array job like so:
    # sbatch --array=0-55 04-1-prokka.sh 
#-------------------------------------------------------------------------------
#Setup directories
workdir=/data/users/qcoxon/thesis
data_dir=/data/users/qcoxon/thesis/results/02-assembly/final_renamed
names_array=($(<${workdir}/codes/names.txt))
outdir=${workdir}/results/04-annotation/prokka/${name}
assembly=${data_dir}/${name}_assembly.fasta
#--------------------------------------------------------------
module load prokka/1.14.5-gompi-2021a

prokka ${assembly} --outdir ${outdir} --prefix ${name} --cpus 16 