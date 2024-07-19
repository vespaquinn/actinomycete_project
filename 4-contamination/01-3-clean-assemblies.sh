#!/bin/bash
# Create cleaned assemblies
# this script is very manual, but takes the contigs which were manually curated from kraken2 output and puts them together into a 'cleaned' file
workdir=/data/users/qcoxon/thesis/results/10-extracting-contaminants
dirtydir=${workdir}/contigs
cleandir=${workdir}/cleaned
mkdir -p ${cleandir}

# 1- B67
name=B67
cd ${dirtydir}/${name}_contigs
cat bc2055_assembly.part_ctg.s1__p__c__000000__0.fasta \
bc2055_assembly.part_ctg.s2__p__c__000003__0.fasta \
bc2055_assembly.part_ctg.s2__p__c__000004__0.fasta \
> ${cleandir}/${name}_assembly.fasta

# 2- B13
name=B13
cd ${dirtydir}/${name}_contigs
cp bc2037_assembly.part_ctg.s1__p__l__000000__0.fasta ${cleandir}/${name}_assembly.fasta

# 3- B131
name=B131
cd ${dirtydir}/${name}_contigs
cat bc2073_assembly.part_ctg.s2* > ${cleandir}/${name}_assembly.fasta

# 4- B21
name=B21
cd ${dirtydir}/${name}_contigs
cat bc2040_assembly.part_ctg.s1__p__l__000000__0.fasta \
bc2040_assembly.part_ctg.s2__p__l__000000__0.fasta \
bc2040_assembly.part_ctg.s2__p__l__000001__0.fasta \
> ${cleandir}/${name}_assembly.fasta

# 5 - B50
name=B50
cd ${dirtydir}/${name}_contigs
cat bc2047_assembly.part_ctg.s1__p__l__000003__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000004__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000005__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000006__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000007__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000008__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000009__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000010__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000011__0.fasta \
bc2047_assembly.part_ctg.s1__p__l__000012__0.fasta \
bc2047_assembly.part_ctg.s2__p__l__000001__0.fasta \
bc2047_assembly.part_ctg.s2__p__l__000002__0.fasta \
> ${cleandir}/${name}_assembly.fasta

# 6 - B93
name=B93
cd ${dirtydir}/${name}_contigs
cat bc2057_assembly.part_ctg.s*__p__l* > ${cleandir}/${name}_assembly.fasta

#---- Finally, check the lengths of the cleaned assemblies
cleandir=/data/users/qcoxon/thesis/results/10-extracting-contaminants/cleaned
output_file=${cleandir}/length_summary.txt

# Clear the contents of output_file if it exists, or create a new one
> "$output_file"

for file in "${cleandir}"/*; do
    # Calculate the total sequence length excluding header lines
    length=$(awk '/^>/ {next} {total += length($0)} END {print total}' "${file}")

    # Extract filename without path
    name=$(basename "${file}")

    # Append filename and length to output_file
    echo "${name} ${length}" >> "${output_file}"
done