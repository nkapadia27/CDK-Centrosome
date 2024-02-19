//2019.01.28
//Creates max projection of Slices 2-6 of Channels 2 and 3, saves into separate output folders for each channel
//make the output folders before running macro

// Converts all files in a directory to TIFF - there will be one TIFF file per channel per input file.


/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Channel 2 output directory", style = "directory") outputChannel2
#@ File (label = "Channel 3 output directory", style = "directory") outputChannel3
#@ String (label = "File suffix", value = ".tif") suffix



setBatchMode(true); //supressing windows opening
processFolder(input); //running the command 

print("\nFinished");
showStatus("Finished.");
setBatchMode(false);

	
// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input); //gets the list of files in a folder
	list = Array.sort(list); //orders files
	for (i = 0; i < list.length; i++) { //tells you to cycle through
		if(File.isDirectory(input + File.separator + list[i])){ //is it a folder
			processFolder(input + File.separator + list[i]); //if it is you process the folder, going through the whole function again with this folder as the input
		}
		if(endsWith(list[i], suffix)) { //check it is the right file type
			processFile(input, outputChannel2, list[i], 2); //process file type 2
			processFile(input, outputChannel3, list[i], 3); //process file type 3
		}
	}
}

function processFile(input, output, filename, channel) { //smae function for processing both channels
	file = input + filename;
	run("Bio-Formats Importer", "open=[" + file + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack"); // open image with bioformats
	getDimensions(width, height, sizeC, slices, frames); // get image dimensions width, height, channels, slices, frames
	print("Number of channels: " + sizeC);
	if(sizeC > 1){
		run("Duplicate...", "duplicate channels=" + channel + " slices=2-6"); //duplicate slices 2-6 of channel _
		run("Grouped Z Project...", "projection=[Max Intensity] group=5"); //max project

		index = lastIndexOf(filename, ".");
		filenameWithoutSuffix = substring(filename, 0, index);
		saveName = output + File.separator + filenameWithoutSuffix + "MAX" + channel + suffix;
		run("Bio-Formats Exporter", "save=[" + saveName + "] use compression=Uncompressed"); // save image
		close(); //close all open windows
		print("Saving to: " + output);
	}
	close(); //close all open windows
}


