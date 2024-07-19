#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=90G
#SBATCH --time=06:00:00
#SBATCH --job-name=antismash
#SBATCH --output=/data/users/qcoxon/thesis/errorout/antismash.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/antismash.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# SCRIPT 4.4 Annotate with Antismash 
# version 7.0.0
# Documentation available: https://docs.antismash.secondarymetabolites.org/
#--------------------------------------------------------------
# To run this with sbatch for all final assemblies run an sbatch array job like so:
    # sbatch --array=0-55 04-4-antismash.sh 
#--------------------------------------------------------------
#Setup barcode and name 
names_array=($(</data/users/qcoxon/thesis/codes/names.txt))

i=${SLURM_ARRAY_TASK_ID} 
name=${names_array[$i]}

#Setup directories
workdir=/data/users/qcoxon/thesis
data_dir=/results/04-annotation/prokka/
singdir=${workdir}/containers
outdir=${workdir}/results/04-annoation/antismash/${name}
mkdir -p ${outdir}

# get the genbank file from prokkadir
genbank_file=${data_dir}/${name}/${name}.gbk

# prepare singularity/apptainer
export APPTAINER_TMPDIR=${workdir}/temp
export SINGULARITY_TMPDIR=${workdir}/temp
export APPTAINER_CACHEDIR=${singdir}/apptainer_cache

# run antismash
singularity exec \
--bind ${data_dir} \
--bind ${outdir} \
${singdir}/antismash.sif \
antismash ${genbank_file} --output-dir ${outdir}
