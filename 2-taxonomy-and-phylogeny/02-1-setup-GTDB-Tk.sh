#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G
#SBATCH --time=04:00:00
#SBATCH --job-name=download-gtfbtk-database
#SBATCH --output=/data/users/qcoxon/thesis/errorout/GTDBTK.e
#SBATCH --error=/data/users/qcoxon/thesis/errorout/gtdbtk_install.e
#SBATCH --partition=pibu_el8 
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=quinn.coxon@students.unibe.ch
#-------------------------------------------------
# script to install database for gtdb-tk
# original time alloted 4-00:00:00
#-------------------------------------------------
workdir=/data/users/qcoxon/thesis
singdir=${workdir}/containers
cd ${workdir}/software/gtdbtk
barcodes_array=($(</data/users/qcoxon/thesis/codes/final_barcodes.txt))
names_array=($(</data/users/qcoxon/thesis/codes/final_names.txt))

# step 1. download the databases 
if [ 1 == 0 ]; then 
wget -t 0 --retry-connrefused https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/gtdbtk_data.tar.gz
tar xvzf gtdbtk_data.tar.gz
fi

# step 2. copy over the genomes 
mkdir ${workdir}/software/gtdbtk/genomes
if [ 1 == 0 ]; then
for i in {0..55}; do
barcode=${barcodes_array[$i]}
name=${names_array[$i]}
cp ${workdir}/results/04-annotation/prokka/${barcode}/${barcode}.fna ${workdir}/software/gtdbtk/genomes/${name}.fna
done
fi

# step 3. get the container from dockerhub 
if [ 1 == 1 ]; then
cd ${singdir}
export APPTAINER_TMPDIR=${workdir}/temp
export SINGULARITY_TMPDIR=${workdir}/temp
export APPTAINER_CACHEDIR=${singdir}/apptainer_cache
singularity build gtdb-tk.sif docker://ecogenomic/gtdbtk
fi

