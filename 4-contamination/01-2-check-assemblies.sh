#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=90G
#SBATCH --time=00:30:00
#SBATCH --job-name=check-assemblies
#SBATCH --output=/data/users/qcoxon/thesis/errorout/check-assemblies.o
#SBATCH --error=/data/users/qcoxon/thesis/errorout/check-assemblies.e
#SBATCH --partition=pibu_el8 
#---------------------------------------
## To run this with sbatch for all contaminated assemblies run an sbatch array job like so:
    # sbatch --array=0-6 01-2-check-assemblies.sh
#-------------------------------------------------------------------------------

# 0 --- setup 
workdir="/data/users/qcoxon/thesis"
names_array=($(<${workdir}/codes/contaminated.txt))
barcodes_array=($(<${workdir}/codes/contaminated_barcodes.txt))
kraken_db=/data/databases/kraken/k2_standard

# get name and barcode from slurm task ID and set assembly
i=i=${SLURM_ARRAY_TASK_ID} #0,1,2,3,4,5

name=${names_array[$i]}
barcode=${barcodes_array[$i]}

# get the assembly directory 
results=${workdir}/results/10-extracting-contaminants/contigs/${name}_contigs

# make the output dir
outdir=${workdir}/results/10-extracting-contaminants/reports/${name}_reports
mkdir -p ${outdir}

# loop through the contigs
for file in ${results}/*; do

    # extract the identifiers of the filename 
    id_1=$(grep -o '\.s[1-9]' <<< ${file}  | sed 's/\.//')
    id_2=$(grep -o '[0-9]\{6\}'  <<< ${file}) 
    id="${id_1}_${id_2}"

    # get the assembly
    assembly=${file}


    # load kraken
    module load Kraken2/2.1.2-gompi-2021a

    # run kraken 
    kraken2 --db ${kraken_db} --output ${outdir}/${id}_kraken_output.txt --report ${outdir}/${id}_report.txt ${assembly}
done

#---------------------------------------------------------------------------------
# SUMMARIZE THE RESULTS
#---------------------------------------------------------------------------------
for name in ${names_array[@]};do
    
    # get the results dir
    results=${workdir}/results/10-extracting-contaminants/reports/${name}_reports
    cd ${results}

    # Output file to store the results
    output_file=${results}/kraken_summary.txt

    # Loop through each file in the directory that ends with "_report.txt"
    for file in ${results}/*_report.txt; do
        # Extract the file ID (e.g., s2000002) from the filename
        file_id=$(basename "$file" "_report.txt")

        # Get the last line of the file
        last_line=$(tail -n 1 "$file")

        # Print the file ID and last line to the output file
        echo "${file_id}: ${last_line}" >> "$output_file"
        
    done
    echo ${name}
done