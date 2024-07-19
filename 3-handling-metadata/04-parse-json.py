# Parsing .js files into TSV
# This python script uses the json module to extract the metadata necessary to generate the individual strain.txt annotation files, 
# and the AS.tsv annotation description file. Each strain.txt file is unique, while the AS.tsv file is universal. 
import json 

# setup
i=0
outdir="/home/quinn/thesis/data/antismash/annotation_files"
names_path="/home/quinn/thesis/data/names.txt"

# generate the names array
with open(names_path, 'r') as file:
    names_array = file.read().splitlines()

# setup the annotation_descriptions list and specify the file path
annotation_descriptions = []   
annotation_description_file = f"{outdir}/AS.tsv"

# loop through the names 
for name in names_array:
    json_path=f"/home/quinn/thesis/data/antismash/json_files/{name}.json"
    f = open(json_path,)
    data = json.load(f)

    # generate the custom annotation dictionary 
    custom_annotation = dict()
    
    # loop through the different levels of the json to extract the appropriate data 
    for entry in data:
        regions = entry.get("regions", [])
        for region in regions:
            orfs = region.get("orfs", [])
            clusters = region.get("clusters",[])
            for cluster in clusters:
                cluster_product = cluster.get("product")
            for orf in orfs:
                locus_tag = orf.get("locus_tag")
                gene_type = orf.get("type")
                gene_product = orf.get("product")
                if locus_tag and gene_type:
                    if locus_tag.startswith(name):
                        i +=1 
                        index=(f"AS{i:05}")
                        annotation_descriptions.append((index, gene_type, gene_product, cluster_product))
                        custom_annotation[locus_tag] = index

    # Specify the output file path
    custom_annotation_file = f"{outdir}/{name}_antismash.txt"

    # Open the file in write mode
    with open(custom_annotation_file, 'w') as file:
        # Loop through the dictionary items
        for key, value in custom_annotation.items():
            # Format each key-value pair as a string
            line = f"{key}\t{value}\n"
            # Write the formatted string to the file
            file.write(line)
    print(f"Sucessfully written the custom annotation file for: {name}")

# Finally, write the annotation description file
with open(annotation_description_file, 'w') as file:
    # Loop through the dictionary items
    for index, gene_type, gene_product, cluster_product in annotation_descriptions:
        # Format each key-value pair as a string
        line = f"{index}\t {gene_type} {cluster_product}\n"
        # Write the formatted string to the file
        file.write(line)
print("Successfully written AS.tsv")