# Python file for creating .json metadata files # Updated 13.05.2024
import json
import pandas as pd
from ete3 import NCBITaxa

# Create an instance of NCBITaxa
ncbi_taxa = NCBITaxa()

# Load the metadata from the csv
metadata = pd.read_csv('~/thesis/data/updated_metadata_01_05_2024.csv', na_values=None)

# Loop through each row of metadata 
for index, row in metadata.iterrows():
    # extract metadata 
    name=row['Code']
    species=row['Species (WGS)']
    invitro=row['Strain Invitro activity'] + " in vitro"
    extract=row['Extract Invitro activity '] + " as extract"
    
    # Set the morphology, if none set it to "Morphology unchanged"
    if isinstance(row['P. infestans morphology'],str):
        morph=row['P. infestans morphology']
    else:
        morph="Morphology unchanged"
        
    #
    tags=[invitro,extract,morph]
    if row['In planta activity'] != "ND":
        in_planta=row['In planta activity'] + " in planta"
        print(in_planta)
        tags.append(in_planta)
    if row['Siderophore production '] == "Producer":
        tags.append("Siderophore producer")
    
    # Retrieve the taxid for the species
    taxid_raw = ncbi_taxa.get_name_translator([species])

    # Check if the species name was found in the NCBI Taxonomy database
    if species in taxid_raw:
        taxid=taxid_raw[species][0]
    else:
        taxid=None
    
    # Create the dictionary
    dictionary = {
    "name": name,
    "alternative_name": None,
    "taxid": taxid,
    "restricted": False,
    "tags": tags,
    "representative": name + ".1"
    }
    #print(taxid)
    if 1 == 1:
        # Serializing json
        json_object = json.dumps(dictionary, indent=4)

        file_path = "/home/quinn/thesis/data/json_files/2_trial2/" + name + ".json"
        # Writing to sample.json
        with open(file_path, "w") as outfile:
            outfile.write(json_object)

