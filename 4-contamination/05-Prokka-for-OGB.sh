#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=90G
#SBATCH --time=00:15:00
#SBATCH --job-name=all-prokka
#SBATCH --output=/data/users/qcoxon/thesis/errorout/prokka-rerun-cleaned.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/prokka-rerun-cleaned.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# Annotate with Prokka. Test case took 4.08 minutes with 8 threads. 
# Prokka version 1.14.5 [https://github.com/tseemann/prokka]
#--------------------------------------------------------------
# To run this with sbatch for all final assemblies run an sbatch array job like so:
    # sbatch --array=0-5 03-Prokka-for-OGB.sh
#--------------------------------------------------------------

#Setup name and get taxonomy 
names_array=($(<"/data/users/qcoxon/thesis/results/11-rerunning-for-contaminated/2-GTDB-Tk/cleaned_names.txt"))
genera_array=($(<"/data/users/qcoxon/thesis/results/11-rerunning-for-contaminated/2-GTDB-Tk/cleaned_genera.txt"))
species_array=($(<"/data/users/qcoxon/thesis/results/11-rerunning-for-contaminated/2-GTDB-Tk/cleaned_species.txt"))

i=${SLURM_ARRAY_TASK_ID} 
name=${names_array[$i]}
species=${species_array[$i]}
genus=${genera_array[$i]}

#Setup directories
workdir=/data/users/qcoxon/thesis
datadir=${workdir}/results/10-extracting-contaminants/cleaned
outdir=${workdir}/results/11-rerunning-for-contaminated/3-prokka-for-OGB/${name}
assembly=${datadir}/${name}_assembly.fasta

#--------------------------------------------------------------
# To run this with sbatch for all final assemblies use the helper script submit.sh 
# OR manually with sbatch 04-prokka-run.sh [barcode] 
    #e.g., sbatch 04=prokka-run.sh bc2033 
#-------------------------------------------------------------
module load prokka/1.14.5-gompi-2021a

prokka ${assembly} --outdir ${outdir} --prefix ${name}.1 --cpus 16 --strain ${name} --locustag ${name}.1 --genus ${genus} --species ${species}
