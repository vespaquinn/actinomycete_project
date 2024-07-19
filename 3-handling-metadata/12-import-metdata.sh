#!/bin/bash

# set up impor orgins
file_dir=/home/ogb_admin/support/annotation_files
genome_json_dir=${file_dir}/genome_jsons
organism_json_dir=${file_dir}/organism_jsons
annotation_dir=${file_dir}/annotation_files


# set up destinations 
organisms_dir=/home/ogb_admin/ogb_instance/opengenomebrowser-docker-template/folder_structure/organisms 

# set up names
names_array=($(</home/ogb_admin/support/names.txt))


for name in ${names_array[@]}; do
    # replace genome json 
    cp ${genome_json_dir}/${name}_genome.json ${organisms_dir}/${name}/genomes/${name}.1/genome.json
    
    # replace the organism.json 
    cp ${organism_json_dir}/${name}.json ${organisms_dir}/${name}/organism.json

    # add the custom annotation files
    cp ${annotation_dir}/${name}_antismash.txt ${organisms_dir}/${name}/genomes/${name}.1

    done