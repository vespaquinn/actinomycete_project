#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G
#SBATCH --time=04:00:00
#SBATCH --job-name=ANIclustermap-
#SBATCH --output=/data/users/qcoxon/thesis/errorout/ANI_rerun.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/ANI_rerun.e
#SBATCH --partition=pibu_el8 
#-------------------------------------------------
# 
#-------------------------------------------------
# setup 
workdir=/data/users/qcoxon/thesis
names_array=("B13" "B21" "B67")
sing_image=${workdir}/containers/aniclustermap.sif 
outdir=${workdir}/results/11-rerunning-for-contaminated/6-ANI
fasta_dir=${workdir}/results/11-rerunning-for-contaminated/6-ANI/fastasq
mkdir -p ${fasta_dir}
# get the fastas temporarily to the fastasdir 
cp -r ${workdir}/results/02-assembly/final_renamed/* ${fasta_dir}

#(rename the cleaned fastas to the same format as the others)
for name in ${names_array[@]};do 
cp ${workdir}/results/10-extracting-contaminants/cleaned/${name}_assembly.fasta ${fasta_dir}/${name}.fasta 
done

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

# remove the temporary fasta files
rm -r ${fasta_dir}/*