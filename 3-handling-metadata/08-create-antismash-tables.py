# Parsing .js files into TSV
# This python script uses the json module to extract the metadata necessary to generate the individual strain.txt annotation files, 
# and the AS.tsv annotation description file. Each strain.txt file is unique, while the AS.tsv file is universal. 
import json 


outdir="/home/quinn/thesis/data/antismash/genome_json_files/3-with-linked-tables"
names_path="/home/quinn/thesis/data/names.txt"

# generate the names array
with open(names_path, 'r') as file:
    names_array = file.read().splitlines()

# create a set of all clusters (products)
clusters_set= set()

for name in names_array:
    # load the antismash data
    antismash_json_path=f"/home/quinn/thesis/data/antismash/json_files/{name}.json"
    f = open(antismash_json_path,)
    antismash_json = json.load(f)

    # loop through the different levels of the json to extract the cluster products
    for entry in antismash_json:
        regions = entry.get("regions", [])
        for region in regions:
            cluster_type = region.get("type")
            
            # add the cluster type to the set
            clusters_set.add(cluster_type)

# create a dictionary with each cluster as a key, and an empty set as each value 
clusters_dict = {element: set() for element in clusters_set}

# now loop through all the json files again, and append the strain names to each cluster 
for name in names_array:
    # load the antismash data
    antismash_json_path=f"/home/quinn/thesis/data/antismash/json_files/{name}.json"
    f = open(antismash_json_path,)
    antismash_json = json.load(f)

    # loop through the different levels of the json to extract the cluster products
    for entry in antismash_json:
        regions = entry.get("regions", [])
        for region in regions:
            cluster_type = region.get("type")
            
            # use the cluster type as a key, and add the strain name to the value set
            clusters_dict[cluster_type].add(f"{name}")

# now we have a dictionary of *all* clusters, we need unique dictionaries of regions and cluster numbers for each strain 

for name in names_array:
    # load the antismash data
    antismash_json_path=f"/home/quinn/thesis/data/antismash/json_files/{name}.json"
    f = open(antismash_json_path,)
    antismash_json = json.load(f)
    
    # create the unique clusters set for this strain 
    strain_clusters = set()

    # loop through the different levels of the json to extract the cluster products
    for entry in antismash_json:
        regions = entry.get("regions", [])
        for region in regions:
            cluster_type = region.get("type")
    
            # add the cluster type to the set
            strain_clusters.add(cluster_type)
    
    # now create regions and cluster numbers dictionaries (the values don't need to be sets this time as they can't be duplicates)
    strain_regions_dict = {element: [] for element in strain_clusters}
    strain_numbers_dict = {element: [] for element in strain_clusters}
    
    # loop through the different levels of the json to extract the regions and cluster numbers 
            # (each value will be a tupple)
    for entry in antismash_json:
        regions = entry.get("regions", [])
        for region in regions:
            cluster_type = region.get("type")
            region_start = region.get("start")        
            region_end = region.get("end")        
            region_indices = f"{region_start}-{region_end}"
            cluster_number = region.get("idx")
            
            # add these to the dictionaries 
            strain_regions_dict[cluster_type].append(region_indices)
            strain_numbers_dict[cluster_type].append(cluster_number)
            
            # create the custom table format 
            custom_table =  {
                "index_col": "Product",
                "rows": [],
                "region_cols": [
                    "Also Present In"
                ]
            }
        
            
            # Loop through the dictionary and append the custom table 
            for cluster, numbers in strain_numbers_dict.items():
                
                # extract the variables 
                table_product = cluster
                table_regions = strain_regions_dict[cluster]
                table_cluster_numbers = [str(number) for number in numbers]
                table_also_present_in = list(clusters_dict[cluster]) # convert set to list to make it JSON serializable 
                table_also_present_in.remove(name) # remove itself from 'also present in' 

                # append the table
                custom_table["rows"].append({
                "Product": table_product, 
                "Regions":  ", ".join(table_regions),
                "Clusters": ", ".join(table_cluster_numbers),
                "Also Present In": ", ".join(table_also_present_in)                  
                })
                
                # load in the genome JSON object 
                genome_json_path=f"/home/quinn/thesis/data/antismash/genome_json_files/2-with-busco-and-annotation/{name}_genome.json"
                f = open(genome_json_path,)
                genome_json = json.load(f)    
                
                # add the table to the JSON object 
                genome_json["custom_tables"]["antiSmash Products"] = custom_table 
                
                # serialise the json object 
                json_object = json.dumps(genome_json, indent = 2)
                
                # write the new genome.json file 
                file_path= f"{outdir}/{name}_genome.json"
                with open(file_path, "w") as outfile:
                    outfile.write(json_object)

                