#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=128G
#SBATCH --time=03:00:00
#SBATCH --job-name=pgap_setup
#SBATCH --output=/data/users/qcoxon/thesis/errorout/pgap_setup.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/pgap_setup.e
#SBATCH --partition=pibu_el8 
#-----------------------------------------------------------------
# SCRIPT 4-2-0-installing-PGAP
# version 2023-10-03.build7061
# Run this script twice, using the if statements to either install pgap, or test pgap
#-----------------------------------------------------------------
workdir=/data/users/qcoxon/thesis
singdir=${workdir}/containers
mkdir -p ${singdir}
#------------------------------------------------------------------
# Change into the right directory and IMPORTANTLY set the tmpdir to one in the workdir
# (the default is in your home dir which doesn't have enough space)
cd ${singdir}
export APPTAINER_TMPDIR=${workdir}/temp
export SINGULARITY_TMPDIR=${workdir}/temp

# Add conditional do diable this part of script if needed
if [ 1 == 0 ]; then
    ##  Follow the 'Quick Start' tutorial on installing pgap 
    # download the file
    wget -O pgap.py https://github.com/ncbi/pgap/raw/prod/scripts/pgap.py

    # Install the pipeline using the -D to indicate which 'dockerlike' programme to use i.e., singularity 
        # By default it will install in $HOME/.pgap, but this location can 
        # be changed by setting environmental variable PGAP_INPUT_DIR.
    export PGAP_INPUT_DIR=${singdir}/pgap
    chmod +x pgap.py
    ./pgap.py --update -D singularity 
fi

if [ 1 == 1 ]; then 
    # Test by running the pipeline on the Mycoplasmoides genitalium genome provided with the installation:
    ./pgap.py -D singularity -r -o mg37_results -g ${singdir}/pgap/test_genomes/MG37/ASM2732v1.annotation.nucleotide.1.fasta -s 'Mycoplasmoides genitalium'
fi