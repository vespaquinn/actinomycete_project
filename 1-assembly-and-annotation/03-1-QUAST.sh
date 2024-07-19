#!/usr/bin/env bash
#SBATCH --mail-user=quinn.coxon@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --job-name=QUAST
#SBATCH --output=/data/users/qcoxon/thesis/errorout/QUAST.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/quast.e
#SBATCH --cpus-per-task=24
#SBATCH --mem=60G
#SBATCH --time=08:00:00
#SBATCH --partition=pibu_el8 
#-----------------------------------------------------------------------------
# SCRIPT 3.1 - Assembly QC with QUAST
# version 5.0.2
# Documentation available: https://quast.sourceforge.net/docs/manual.html
#-----------------------------------------------------------------------------
#Setup directories
workdir=/data/users/qcoxon/thesis
data_dir=/data/users/qcoxon/thesis/results/02-assembly/fasta
names=($(<${workdir}/codes/names.txt))
barcodes=($(<${workdir}/codes/barcodes.txt))
outdir=${workdir}/results/03-assemblyQC/QUAST/hifiasm
mkdir -p ${outdir}

#Setup QUAST variables 
hifiasm=${data_dir}/hifiasm/*.p_ctg.fa
smrtlink=${data_dir}/smrtlink/*_assembly.fasta 
flye=${data_dir}/flye/*_assembly.fasta 

#Run QUAST to assess quality of the assemblies
module load QUAST/5.0.2-foss-2021a
python /software/software/QUAST/5.0.2-foss-2021a/bin/quast.py ${hifiasm} -o ${outdir} -m 3000 -t 24 -l ${names} -x 7000 

#Options entered here are:
    #"-o": Directory to store all result files
    #"-m": Lower threshold for contig length.
    #"-t": Maximum number of threads
    #"-l": Human-readable assembly names. Those names will be used in reports, plots and logs.
    #"-x": Lower threshold for extensive misassembly size. All relocations with inconsistency less than extensive-mis-size are counted as local misassemblies
#--------------------------------------------------------------------------------------------------------------------------
#------------- Repeat for Flye -------------

outdir=${workdir}/results/03-assemblyQC/QUAST/flye
mkdir -p ${outdir}

#Run QUAST to assess quality of the assemblies
python /software/software/QUAST/5.0.2-foss-2021a/bin/quast.py ${flye} -o ${outdir} -m 3000 -t 24 -l ${names} -x 7000 

#------------- Repeat for SMRTLink -------------
outdir=${workdir}/results/03-assemblyQC/QUAST/smrtlink
mkdir -p ${outdir}

#Run QUAST to assess quality of the assemblies
python /software/software/QUAST/5.0.2-foss-2021a/bin/quast.py ${smrtlink} -o ${outdir} -m 3000 -t 24 -l ${names} -x 7000 
