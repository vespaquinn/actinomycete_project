# Parsing .js files into TSV
# This python script uses the json module to extract the metadata necessary to generate the individual strain.txt annotation files, 
# and the AS.tsv annotation description file. Each strain.txt file is unique, while the AS.tsv file is universal. 
import json 


outdir="/home/quinn/thesis/data/antismash/genome_json_files/1-with-antismash"
names_path="/home/quinn/thesis/data/names.txt"

# generate the names array
with open(names_path, 'r') as file:
    names_array = file.read().splitlines()

for name in names_array:
    # load the antismash data
    antismash_json_path=f"/home/quinn/thesis/data/antismash/json_files/{name}.json"
    f = open(antismash_json_path,)
    antismash_json = json.load(f)

    # load the genome.json file
    genome_json_path=f"/home/quinn/thesis/data/json_files/genome/{name}.json"
    f = open(genome_json_path,)
    genome_json = json.load(f)

    # Create custom table dictionary with the required structure
    custom_table = {
        "antiSmash Clusters": {
            "index_col": "region",
            "rows": [],
            "region_cols": [
                "type"
            ]
        }
    }

    # loop through the different levels of the json to extract the appropriate data 
    for entry in antismash_json:
        regions = entry.get("regions", [])
        for region in regions:
            index = region.get("idx")
            reg_start = region.get("start")
            reg_end = region.get("end")
            cluster_type = region.get("type")
            
            # Create a dictionary for each region and add it to custom_table
            custom_table["antiSmash Clusters"]["rows"].append({
                "region": index,
                "type": cluster_type,  
                "start-end": f"{reg_start}-{reg_end}"                    
            })
    # append the genome.json file with the custom table
    genome_json["custom_tables"] = custom_table

    # Serializing json
    json_object = json.dumps(genome_json, indent = 2)

    file_path = f"{outdir}/{name}_genome.json"
    
    # Writing to sample.json
    with open(file_path, "w") as outfile:
        outfile.write(json_object)

                    
