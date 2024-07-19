#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=120G
#SBATCH --time=3-00:00:00
#SBATCH --job-name=run-gtfbtk-
#SBATCH --output=/data/users/qcoxon/thesis/errorout/gtdbtk.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/gtdbtk.e
#SBATCH --partition=pibu_el8 
#-------------------------------------------------
# Script to test gtdbtk, originally ran out of time with 1 thread and 04:00:00 time. 
# Second run, with 1-00:00:00 nearly completed but was cut off at the last minute.
#-------------------------------------------------
# general setup 
workdir=/data/users/qcoxon/thesis
singdir=${workdir}/containers

# gtdbk specific setup 
refdir=${workdir}/software/database_gtdbk_try2/release214/
gtdbk_io=${workdir}/software/gtdbtk_io

# setup singularity 
export APPTAINER_TMPDIR=${workdir}/temp
export APPTAINER_CACHEDIR=${singdir}/apptainer_cache
cd ${singdir}

# run the test 
singularity exec \
--bind ${refdir}:/refdata \
--bind ${gtdbk_io}:/data \
gtdb-tk.sif gtdbtk classify_wf --genome_dir /data/genomes --out_dir /data/output --mash_db /data/mash --cpus 8


