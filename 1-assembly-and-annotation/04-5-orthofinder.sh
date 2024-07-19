#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=90G
#SBATCH --time=12:00:00
#SBATCH --job-name=orthofinder-test
#SBATCH --output=/data/users/qcoxon/thesis/errorout/orthofinder-rerun.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/orthofinder-rerun.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# SCRIPT 4.5 Annotate with OrthoFinder.
# version 2.5.5
# Documentation Available: https://github.com/davidemms/OrthoFinder
#--------------------------------------------------------------
workdir=/data/users/qcoxon/thesis
fastas=${workdir}/orthofinder/fastas
orthofinder_dir=${workdir}/orthofinder
orthofinder_sif=${workdir}/containers/orthofinder.sif 

cd ${orthofinder_dir}

# prepare singularity/apptainer
export APPTAINER_TMPDIR=${workdir}/temp
export SINGULARITY_TMPDIR=${workdir}/temp
export APPTAINER_CACHEDIR=${workdir}/containers/apptainer_cache

# run antismash
singularity exec \
--bind ${orthofinder_dir} \
${orthofinder_sif} orthofinder -f ${fastas}
