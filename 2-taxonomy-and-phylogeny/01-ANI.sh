#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G
#SBATCH --time=04:00:00
#SBATCH --job-name=run-ANIclustermap-
#SBATCH --output=/data/users/qcoxon/thesis/errorout/ANI_rerun.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/ANI_rerun.e
#SBATCH --partition=pibu_el8 
#-------------------------------------------------
# SCRIPT Generate ANI
# ANIClustermap version 1.3.0
# FastANi version 1.33
#-------------------------------------------------
# setup 
workdir=/data/users/qcoxon/thesis
names_array=($(<${workdir}/codes/names.txt ))
sing_image=${workdir}/containers/aniclustermap.sif 
outdir=${workdir}/results/6-ANI
mkdir -p ${outdir}

fasta_dir=${workdir}/results/02-assembly/final_renamed

# prepare singularity 
export APPTAINER_TMPDIR=${workdir}/temp
export APPTAINER_CACHEDIR=${singdir}/apptainer_cache

# run the container 
cd ${workdir}/containers

singularity exec \
--bind ${fasta_dir}:/fasta \
--bind ${outdir}:/out \
aniclustermap.sif \
ANIclustermap -i /fasta -o /out
