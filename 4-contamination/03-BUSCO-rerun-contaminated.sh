#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=90G
#SBATCH --time=06:00:00
#SBATCH --job-name=busco-test
#SBATCH --output=/data/users/qcoxon/thesis/errorout/busco-rerun.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/busco-rerun.e
#SBATCH --partition=pibu_el8 
#--------------------------------------------------------------
# Check annotations with busco. 
# busco version 5.4.2-foss-2021a
#--------------------------------------------------------------
#--------------------------------------------------------------
# To run this with sbatch for all final assemblies run an sbatch array job like so:
    # sbatch --array=0-5 04-BUSCO-rerun-contaminated.sh 
#-------------------------------------------------------------

#Setup directories
workdir=/data/users/qcoxon/thesis
tempdir=${workdir}/temp
datadir=${workdir}/results/10-extracting-contaminants/cleaned
outdir=${workdir}/results/11-rerunning-for-contaminated/4-BUSCO
mkdir -p ${outdir}
cd ${outdir}
names_array=($(<${workdir}/codes/cleaned_names.txt ))
i=${SLURM_ARRAY_TASK_ID} 
name=${names_array[$i]}
assembly=${datadir}/${name}_assembly.fasta



# Create 'cleaned up' fasta for busco that uses _ instead of / (as / causes fatal BUSCO error)
cp ${assembly} ${tempdir}
sed -i 's/\//_/g' ${tempdir}/${name}_assembly.fasta

assembly_cleaned=${tempdir}/${name}_assembly.fasta
echo ${name}

#Load module
module load BUSCO/5.4.2-foss-2021a

#Run BUSCO
busco -i ${assembly_cleaned} -m genome -l actinobacteria_phylum_odb10 -o ${name} -c 8 -f
    # -i input file (assembly)
    # -m mode (genome,transcriptome,protein)
    # -l lineage (available lineages can be found with busco --list-datasets)
    # -o output name (NB. NOT output directory) 
    # -c cpu number (number of threads)
    # -f force - overwrite existing data if present 

#Remove the temporary assembly file 
rm ${assembly_cleaned}