# Parsing .js files into TSV
# This python script uses the json module to extract the metadata necessary to generate the individual strain.txt annotation files, 
# and the AS.tsv annotation description file. Each strain.txt file is unique, while the AS.tsv file is universal. 
import json 


outdir="/home/quinn/thesis/data/antismash/genome_json_files/2-with-busco-and-annotation"
names_path="/home/quinn/thesis/data/names.txt"

# generate the names array
with open(names_path, 'r') as file:
    names_array = file.read().splitlines()
    
# loop through names
for name in names_array: 
    
    # load the busco data
    busco_json_path=f"/home/quinn/thesis/data/antismash/busco/{name}_busco.json"
    f = open(busco_json_path,)
    busco_json = json.load(f)

    # load the genome.json file
    genome_json_path=f"/home/quinn/thesis/data/json_files/genome/{name}.json"
    f = open(genome_json_path,)
    genome_json = json.load(f)

    # extract the "results" section from the json
    results = busco_json.get("results", {})

    # extract each result 
    busco_C = int(results.get("Complete"))
    busco_S = int(results.get("Single copy"))
    busco_F = int(results.get("Fragmented"))
    busco_M = int(results.get("Missing"))
    busco_T = int(results.get("n_markers"))
    busco_D = int(results.get("Multi copy"))
            
    # create the dictionary 
    busco_data = {
        "C": busco_C,
        "D": busco_D,
        "F": busco_F,
        "M": busco_M,
        "S": busco_S,
        "T": busco_T,
        "dataset": "actinobacteria_phylum_odb10",
        "dataset_creation_date": "2024-01-08"
        }

    # Append this to the genome.json file 
    genome_json["BUSCO"] = busco_data
    
    # Add the custom annotation details 
    custom_annotation = {
        "date": "2024-05-16",
        "file": f"{name}_antismash.txt",
        "type": "AS"
    }
    # Update the contaminated tag if necessary 
    contaminated =["B13", "B21", "B67"]
    if name in contaminated:
        genome_json["tags"] = ["isolated from contaminated sample"]
    else:
        genome_json["tags"] = []
        
    genome_json["custom_annotations"] = [custom_annotation]
    
    # Serializing json
    json_object = json.dumps(genome_json, indent = 2)

    file_path = f"{outdir}/{name}_genome.json"

    # Writing to sample.json
    with open(file_path, "w") as outfile:
        outfile.write(json_object)

                        
