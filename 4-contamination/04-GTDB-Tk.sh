#!/bin/bash
#SBATCH --cpus-per-task=32
#SBATCH --mem=90G
#SBATCH --time=2-00:15:00
#SBATCH --job-name=gtdb-tk
#SBATCH --output=/data/users/qcoxon/thesis/errorout/gtdbtk-rerun_%j.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/gtdbtk-rerun_%j.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# Rerun GTDB-Tk with the contaminated assemblies 
#--------------------------------------------------------------
# This run is only to get the taxonomy, a separate run will be done to include the contaminated assemblies with the others for 
# a phylogeny 
#--------------------------------------------------------------
# To run this with sbatch for all final assemblies run an sbatch array job like so:
    # sbatch --array=0-4 01-prokka-for-GTDK-tk-contaminated.sh
#--------------------------------------------------------------
# setup directories
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/results/11-rerunning-for-contaminated/1-prokka-for-gtdbtk
singdir=${workdir}/containers
software_dir=${workdir}/software
names_array=($(<${workdir}/codes/cleaned_names.txt ))

# create a gtdbtk_io directory for this run 
genome_dir=${software_dir}/gtdbtk_io_contaminated_run/genomes
mkdir -p ${genome_dir}

# copy the genomes into this directory 
for name in ${names_array[@]};do
    cp ${datadir}/${name}/${name}.fna ${genome_dir}
done

# gtdbk specific setup 
refdir=${software_dir}/database_gtdbk_try2/release214/
gtdbk_io=${software_dir}/gtdbtk_io_contaminated_run

# setup singularity 
export APPTAINER_TMPDIR=${workdir}/temp
export APPTAINER_CACHEDIR=${singdir}/apptainer_cache
cd ${singdir}

# run GTDB-Tk
singularity exec \
--bind ${refdir}:/refdata \
--bind ${gtdbk_io}:/data \
gtdb-tk.sif gtdbtk classify_wf --genome_dir /data/genomes --out_dir /data/output --mash_db /data/mash --cpus 32
