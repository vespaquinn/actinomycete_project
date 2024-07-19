#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=90G
#SBATCH --time=00:30:00
#SBATCH --job-name=all-prokka
#SBATCH --output=/data/users/qcoxon/thesis/errorout/prokka2/PROKKA_updated_tax_test.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/prokka2/prokka_updated_tax_test.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# Annotate with Prokka using the new taxonomy and prefixes needed for OGB
# Prokka version 1.14.5 [https://github.com/tseemann/prokka]
#--------------------------------------------------------------
# To run this with sbatch for all final assemblies run an sbatch array job like so:
    # sbatch --array=1-55 03-prokka-new-taxonomy.sh 
#--------------------------------------------------------------
#Setup barcode and name 
names_array=($(</data/users/qcoxon/thesis/codes/names.txt))
genera_array=($(</data/users/qcoxon/thesis/codes/genera.txt))
species_array=($(</data/users/qcoxon/thesis/codes/species.txt))

i=${SLURM_ARRAY_TASK_ID} 
name=${names_array[$i]}
species=${species_array[$i]}
genus=${genera_array[$i]}

#Setup directories
workdir=/data/users/qcoxon/thesis
data_dir=/data/users/qcoxon/thesis/results/02-assembly/final_renamed
outdir=${workdir}/results/06-annotation-for-ogb/prokka_updated_taxonomy/${name}
assembly=${data_dir}/${name}.fasta

#--------------------------------------------------------------

module load prokka/1.14.5-gompi-2021a

prokka ${assembly} --outdir ${outdir} --prefix ${name}.1 --cpus 16 --strain ${name} --locustag ${name}.1 --genus ${genus} --species ${species}
