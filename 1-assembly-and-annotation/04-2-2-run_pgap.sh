#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=90G
#SBATCH --time=06:00:00
#SBATCH --job-name=pgap-run
#SBATCH --output=/data/users/qcoxon/thesis/errorout/pgap_%j.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/pgap_%j.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# SCRIPT 4.2.2 Annotate with PGAP. 
# version 2023-10-03.build7061
# Documentation available: https://github.com/ncbi/pgap
#--------------------------------------------------------------
# To run this with sbatch for all final assemblies run an sbatch array job like so:
    # sbatch --array=0-55 04-2-pgap-run.sh 
#-------------------------------------------------------------
#Setup directories
workdir=/data/users/qcoxon/thesis
singdir=${workdir}/containers
datadir=/data/users/qcoxon/thesis/results/02-assembly/final_renamed
outdir=${workdir}/results/04-annotation/pgap
mkdir ${outdir}

#Setup name and name 
names_array=($(<${workdir}/codes/final_names.txt))
i=${SLURM_ARRAY_TASK_ID} 
name=${names_array[$i]}

assembly=${datadir}/${name}_assembly.fasta
# Set singularity tempdir 
export APPTAINER_TMPDIR=${workdir}/temp
export SINGULARITY_TMPDIR=${workdir}/temp

# Change into pgap directory 
cd ${singdir}
# Ensure output dir doesn't exist (e.g. from previous failed run)
rm -r ${outdir}/${name}
# run PGAP
./pgap.py -r -D singularity -o ${outdir}/${name} -g ${assembly} -s ${name}
