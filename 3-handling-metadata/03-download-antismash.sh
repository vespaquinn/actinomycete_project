#!/bin/bash
# this script downloads the antismash regions.js files from the cluster
# and then uses javascript to extract the useful data into json format. 

# 1- setup
# save the strain names into an array to loop through and setup outdir 
names_array=($(</home/quinn/thesis/data/names.txt))

outdir=/home/quinn/thesis/data/antismash/js_files

antismash_dir=/data/users/qcoxon/thesis/results/08-antiSMASH


cd ${outdir}

# loop through strains 
for name in ${names_array[@]}; do
    # create separate directory for each strain 
    mkdir ${outdir}/${name}
    cd ${outdir}/${name}
    # copy the 'convert-to-json' script over to directory (must be there as script uses relative paths)
    cp /home/quinn/thesis/scripts/convert-to-json.js .
    # download the regions.js file
    scp qcoxon@login8.hpc.binf.unibe.ch:${antismash_dir}/${name}/regions.js .
    # add the export module to the end of the file so it can be read by the conversion script 
    echo "module.exports = recordData;" >> regions.js
    # run the conversion script with node
    node convert-to-json.js
done


json_dir=/home/quinn/thesis/data/antismash/json_files
mkdir ${json_dir}

for name in ${names_array[@]}; do
    cp ${outdir}/${name}/recordData.json ${json_dir}/${name}.json
done