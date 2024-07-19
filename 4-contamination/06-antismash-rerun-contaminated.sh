#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=90G
#SBATCH --time=02:00:00
#SBATCH --job-name=rerun-antismash
#SBATCH --output=/data/users/qcoxon/thesis/errorout/antismash-rerun.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/antismash-rerun.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# Annotate BGCs with AntiSMASH
#--------------------------------------------------------------
# To run this with sbatch for all final assemblies run an sbatch array job like so:
    # sbatch --array=0-2 05-antismash-rerun-contaminated.sh 
#--------------------------------------------------------------
#Setup barcode and name 
names_array=("B13" "B21" "B67")

i=${SLURM_ARRAY_TASK_ID} 
name=${names_array[$i]}

#Setup directories
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/results/11-rerunning-for-contaminated/3-prokka-for-OGB
singdir=${workdir}/containers
outdir=${workdir}/results/11-rerunning-for-contaminated/5-antismash/${name}
mkdir -p ${outdir}

# get the genbank file from prokkadir
genbank_file=${datadir}/${name}/${name}.1.gbk

# prepare singularity/apptainer
export APPTAINER_TMPDIR=${workdir}/temp
export SINGULARITY_TMPDIR=${workdir}/temp
export APPTAINER_CACHEDIR=${singdir}/apptainer_cache

# run antismash
singularity exec \
--bind ${datadir} \
--bind ${outdir} \
${singdir}/antismash.sif \
antismash ${genbank_file} --output-dir ${outdir}
