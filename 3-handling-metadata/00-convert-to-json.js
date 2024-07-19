// exportToJson.js

const fs = require('fs');
const recordData = require('./regions'); // Adjust the path if necessary

// Convert the variable to a JSON string
const jsonData = JSON.stringify(recordData, null, 2);

// Define the output file path
const outputPath = 'recordData.json';

// Write the JSON string to a file
fs.writeFile(outputPath, jsonData, (err) => {
  if (err) {
    console.error('Error writing to file', err);
  } else {
    console.log('Successfully written to', outputPath);
  }
});
