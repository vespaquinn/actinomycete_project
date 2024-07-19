# Python file for creating genome.json metadata files # Updated 13.05.2024
import json
import pandas as pd
from ete3 import NCBITaxa
import numpy as np

# Create an instance of NCBITaxa
ncbi_taxa = NCBITaxa()

# Load the metadata from the csv
metadata = pd.read_csv('~/thesis/data/updated_metadata_01_05_2024.csv', na_values=None)

# Loop through each row of metadata (i.e., each genome)
for index, row in metadata.iterrows():
    # Load in the template
    f = open("/home/quinn/thesis/data/json_files/genome/example.json")
    json_template = json.load(f)
    
    # Extract the identifier 
    identifier=row['Code'] + ".1"
    name=row['Code']
  
    # Extract and format coordinates and location name
    lat = str(row['City Latitude°N'])
    long= str(row['City Longitude°E '])
    coordinates = lat + '° N ' + long + "° E "
    
    city=row['City']
    state=row['State']
    if not isinstance(state,str):
        state = ""
    if not isinstance(city,str):
        city = ""   
        
    location_name= city + ", "+ state + ", Sudan" 
    #print(location_name)
    # Add data to json 
    json_template['identifier']=identifier
    json_template['isolation_date']="2016" 
    json_template['geographical_coordinates']=coordinates  
    json_template['geographical_name']=location_name
    json_template['library_preparation']="PacBio HiFi Microbial multiplexed library"
    json_template['sequencing_tech']="PacBio Revio"
    json_template['sequencing_date']="05.03.2024"
    json_template['assembly_tool']="SMRTLink"
    json_template['assembly_version']="13"
    json_template['assembly_date']="13.03.2024"
    # Change assembly details for the 3 assemblies that were done with HifiAsm 
    if name in ["B6","B99","B140"]:
        json_template['assembly_tool']="HifiAsm"
        json_template['assembly_version']="0.16.1"
        json_template['assembly_date']="11.03.2024"
        
    # Fix the CDS Tool Names 
    json_template['cds_tool_faa_file']=f"{name}.1.faa"    
    json_template['cds_tool_fnn_file']=f"{name}.1.fnn"    
    json_template['cds_tool_gbk_file']=f"{name}.1.gbk"    
    json_template['cds_tool_gff_file']=f"{name}.1.gff"    
    json_template['assembly_fasta_file']=f"{name}.1.fna"    
    
    if 1 == 1:
        # Serializing json
        json_object = json.dumps(json_template, indent=4)
        file_path = "/home/quinn/thesis/data/json_files/genome" + name + ".json"
        
        # Writing to sample.json
        with open(file_path, "w") as outfile:
            outfile.write(json_object)

