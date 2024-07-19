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

# now loop through each strain 

for name in names_array:
    
    # get the path of the md file 
    md_path=f"/home/quinn/thesis/data/antismash/markdown_files/{name}_genome.md"
    
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
            # Each region will have its own table, so start the table here:
            region_df = pd.DataFrame(columns=["Locus","Product","Function","BLAST"])
            region_id = region.get("idx")
            region_product = region.get("type")
            region_start = region.get("start")
            region_end = region.get("end")
            
            # get the title for the markdown table
            md_title = f" ### Cluster {region_id}: {region_product} ({region_start}-{region_end})"
            
            # Loop through each orf, extract the relavent data, and append it to the df
            orfs = region.get("orfs",[])
            
            for orf in orfs:
                locus = orf.get("locus_tag")
                locus_link = f"https://actinogb-lw.unifr.ch/gene/{locus}"
                locus_md = f"[{locus}]({locus_link})"
                product = orf.get("product")
                function = orf.get("type")
                blast_seq = orf.get("translation")
                blast_link = f"https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE=Proteins&PROGRAM=blastp&BLAST_PROGRAMS=blastp&QUERY={blast_seq}&LINK_LOC=protein&PAGE_TYPE=BlastSearch"
                blast_md = f"[BLAST]({blast_link})"
                
                # append this data to the df
                new_row = pd.DataFrame([[locus_md, product, function, blast_md]], columns=["Locus", "Product", "Function", "BLAST"])
                region_df = pd.concat([region_df, new_row], ignore_index=True)
                
            # Convert the pandas df to markdown format 
            markdown_table = region_df.to_markdown(index=False)
            
            # Write the md table
            with open(md_path, "a") as outfile:
                outfile.write(f"\n{md_title}\n") 
                outfile.write(markdown_table)   
                            
                