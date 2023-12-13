//Macro to tell if two ROIs intersect. In this case used to identify which SPBs align with which Cells
//always change the numbers at the top to match how many ROIs are in each ROIset
//always load SPB into ROI manager before Cell
//SPB means Sid4-mRFP mask
spbCount = 680;
cellCount = 531;


roiManager("List");

for (spb = 0 ; spb < spbCount ; spb++) {
	for (cell = spbCount ; cell < spbCount+cellCount ; cell++) {
		roiManager("select", spb);
		
		//get slice information
		SPBt = getResult("T", spb);
		SPBname = Roi.getName();
		roiManager("select", cell);
		Cellz = getResult("Z", cell);
		Cellname = Roi.getName();
	
		//if SPB t frame is less than cell z frame, we've gone too far so stop the code. 
		//If it is more, we want to keep going, so continue means to go back through the code again. 
		//If neither are satistfied, it'll keep going forward
		if (SPBt < Cellz) {
			break;
		}
		if (SPBt > Cellz) {
			continue;
		}
		//check for intersection and print results
		roiManager('select', newArray(spb, cell));
		roiManager("AND");
		if (selectionType > -1) {
			print("SPB,",SPBname,",Cell,", Cellname, ",intersect");
			break;
		}
	}
}
