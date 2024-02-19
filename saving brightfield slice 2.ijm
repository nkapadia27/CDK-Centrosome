//2019.01.28
//make the output folders before running macro

// Converts all files in a directory to TIFF - there will be one TIFF file per channel per input file.


/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Channel 1 output directory", style = "directory") outputChannel1
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
			duplicateSlice2FromChannel(input, outputChannel1, list[i], 1); //process file type 2
			//getMaxOfSlices2To6(input, outputChannel2, list[i], 2); //process file type 3
		}
	}
}

function duplicateSlice2FromChannel(input, output, filename, channel) {
	file = input + filename;
	run("Bio-Formats Importer", "open=[" + file + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack"); // open image with bioformats
	run("Duplicate...", "duplicate channels=" + channel + " slices=2"); //duplicate slices 2 of channel _
	index = lastIndexOf(filename, ".");
	filenameWithoutSuffix = substring(filename, 0, index);
	saveName = output + File.separator + filenameWithoutSuffix + "BRIGHTFIELD" + channel + suffix;
	run("Bio-Formats Exporter", "save=[" + saveName + "] use compression=Uncompressed"); // save image
	close(); //close all open windows
	print("Saving to: " + output);
}



