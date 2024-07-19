#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=90G
#SBATCH --time=00:30:00
#SBATCH --job-name=separate-contigs
#SBATCH --output=/data/users/qcoxon/thesis/errorout/separate-contigs.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/separate-contigs.e
#SBATCH --partition=pibu_el8 
#---------------------------------------
## To run this with sbatch for all contaminated assemblies run an sbatch array job like so:
    # sbatch --array=0-6 01-split-assemblies.sh
#-------------------------------------------------------------------------------

# 0 --- setup 
workdir="/data/users/qcoxon/thesis"
datadir=${workdir}/results/02-assembly/fasta/smrtlink
results=${workdir}/results/10-extracting-contaminants
names_array=($(<${workdir}/codes/contaminated.txt))
barcodes_array=($(<${workdir}/codes/contaminated_barcodes.txt))

# get name and barcode from slurm task ID and set assembly
i=${SLURM_ARRAY_TASK_ID} 

name=${names_array[$i]}
barcode=${barcodes_array[$i]}

assembly=${datadir}/${barcode}_assembly.fasta 

# for B53 use the hifiasm assembly
if [ ${name} == "B53" ]; then
    assembly=${workdir}/results/02-assembly/fasta/hifiasm/${barcode}.p_ctg.fa
fi

# create outdir
outdir=${results}/contigs/${name}_contigs
mkdir -p ${outdir}

# load seq kit and split the smrtlink assemblies
module load SeqKit/2.6.1

seqkit split -i ${assembly} -O ${outdir}