#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=90G
#SBATCH --time=00:15:00
#SBATCH --job-name=all-prokka
#SBATCH --output=/data/users/qcoxon/thesis/errorout/rerunning-prokka_%j.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/rerunning-prokka_%j.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# Annotate with Prokka. 
# Prokka version 1.14.5 
#--------------------------------------------------------------
# This run must be done first to allow GTDB-Tk to then assign taxonomy
# Once this is produced, Prokka must be run again in the format needed for 
# OGB (i.e., with tax IDs etc.)
#--------------------------------------------------------------
# To run this with sbatch for all final assemblies run an sbatch array job like so:
    # sbatch --array=0-4 01-prokka-for-GTDK-tk-contaminated.sh
#--------------------------------------------------------------
# setup directories
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/results/10-extracting-contaminants/cleaned
outdir=${workdir}/results/11-rerunning-for-contaminated/1-prokka-for-gtdbtk

# get name and assembly
names_array=($(<${workdir}/codes/cleaned_names.txt ))
i=${SLURM_ARRAY_TASK_ID} 
name=${names_array[$i]}
assembly=${datadir}/${name}_assembly.fasta

# make strain outdir
strain_outdir=${outdir}/${name}

# run prokka 
module load prokka/1.14.5-gompi-2021a

prokka ${assembly} --outdir ${strain_outdir} --prefix ${name} --cpus 16 