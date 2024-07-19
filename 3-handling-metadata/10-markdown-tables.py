# Parsing .js files into TSV
# This python script uses the json module to extract the metadata necessary to generate the individual strain.txt annotation files, 
# and the AS.tsv annotation description file. Each strain.txt file is unique, while the AS.tsv file is universal. 
import json 
import pandas as pd

outdir="/home/quinn/thesis/data/antismash/markdown_files"
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
            
            # Initialize an empty DataFrame
            columns = ['Product', 'Regions', 'Clusters', 'Also Present In']
            antismash_df = pd.DataFrame(columns=columns)
            
            # intitialize empty lists
            product_list=[]
            region_list=[]
            cluster_list=[]
            also_pres_list=[]
            
            # Loop through the dictionary and append the custom table 
            for cluster, numbers in strain_numbers_dict.items():
                
                # extract the variables 
                product_list.append(cluster)
                region_list.append(", ".join(strain_regions_dict[cluster]))
                cluster_list.append(", ".join([str(number) for number in numbers]))
                
                also_present_in = (clusters_dict[cluster])
                also_present_w_links = ", ".join([f"[{strain_hit}](https://actinogb-lw.unifr.ch/genome/{strain_hit}.1/)" for strain_hit in also_present_in])
                also_pres_list.append(also_present_w_links)
            
            # Add these to the df 
            antismash_df['Product']=product_list        
            antismash_df['Clusters']=cluster_list        
            antismash_df['Regions']=region_list        
            antismash_df['Also Present In']=also_pres_list
            
            # Convert the pandas df to markdown format 
            markdown_table = antismash_df.to_markdown(index=False)
            
            # Write the md table
            file_path= f"{outdir}/{name}_genome.md"
            with open(file_path, "w") as outfile:
                outfile.write("# Antismash Table\n\n") 
                outfile.write(markdown_table)            