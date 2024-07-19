#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --job-name=move_finals
#SBATCH --output=/data/users/qcoxon/thesis/errorout/move_finals.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/move_finals.e
#SBATCH --partition=pibu_el8 
#------------------------------------------------------------------------------
# SCRIPT 3.3 - Finalising Assemblies
# This script takes the highest quality assemblies (either hifiasm or smrtlink)
# and excludes the contaminated strains. It also renames the assemblies to use the
# strain ID (e.g., B1) instead of the barcode (e.g., bc2033)
#------------------------------------------------------------------------------
## To run this with sbatch for all  assemblies run an sbatch array job like so:
    # sbatch --array=0-57 03-3-finalising_assemblies.sh
#-------------------------------------------------------------------------------
workdir=/data/users/qcoxon/thesis/
hifiasm_data=${workdir}/results/02-assembly/fasta/hifiasm
smrlink_data=${workdir}/results/02-assembly/fasta/smrtlink
outdir=${workdir}/results/02-assembly/final
names_array=($(<${workdir}/codes/names.txt))
barcodes_array=($(<${workdir}/codes/barcodes.txt))

mkdir -p ${outdir}

# move the hifiasm
barcodes=(35 60 75)
for i in "${barcodes[@]}"; do
    mv ${hifiasm_data}/bc20${i}.p_ctg.fa ${outdir}/bc20${i}_assembly.fasta
done

#  generate a list of numbers exlcuded from the smrtlink data
barcodes=($(seq 33 90))
excluded=(35 37 40 47 55 57 60 73 75 )
for num in "${excluded[@]}"; do
    # Remove the number from the array
    barcodes=("${barcodes[@]/$num}")
done

# move the smrtlink
for i in "${barcodes[@]}"; do
    mv ${smrlink_data}/bc20${i}_assembly.fasta ${outdir}/bc20${i}_assembly.fasta
done

#------ rename the assemblies
for i in {0..54}; do
    mv ${outdir}/${barcodes_array[$i]}_assembly.fasta ${outdir}/${names_array[$i]}_assembly.fasta
done

