#!/bin/bash

# set up impor orgins
file_dir=/home/quinn/thesis/data/final_trial_files
genome_json_dir=${file_dir}/genome_jsons
organism_json_dir=${file_dir}/organism_jsons
annotation_dir=${file_dir}/annotation_files
markdown_dir=${file_dir}/markdown_files

prokka_dir=/home/quinn/thesis/data/prokka/prokka_updated_taxonomy

# set up destinations 
folder_structure=/home/quinn/thesis/ogb_attempts/08-with-contaminated-trial/opengenomebrowser-docker-template/folder_structure
organisms_dir=${folder_structure}/organisms 

# set up names
names_array=($(</home/quinn/thesis/data/names.txt))

# export variable for OGB tools
export FOLDER_STRUCTURE=${folder_structure}

# import the genomes 
if [ 1 == 0 ];then
    for i in {0..58}; do
        name=${names_array[$i]}
        import_genome --import_dir=${prokka_dir}/${name}
        position=$((i + 1))
        echo "Completed: ${name}, ${position}/59"
    done
fi

if [ 1 == 1 ];then
    for name in ${names_array[@]}; do
        # replace genome json 
        cp ${genome_json_dir}/${name}_genome.json ${organisms_dir}/${name}/genomes/${name}.1/genome.json
        
        # replace the organism.json 
        cp ${organism_json_dir}/${name}.json ${organisms_dir}/${name}/organism.json

        # add the custom annotation files
        cp ${annotation_dir}/${name}_antismash.txt ${organisms_dir}/${name}/genomes/${name}.1

        # add the custom markdown files
        cp ${markdown_dir}/${name}_genome.md ${organisms_dir}/${name}/genomes/${name}.1/genome.md
    done
fi