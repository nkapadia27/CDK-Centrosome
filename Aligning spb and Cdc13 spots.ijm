//macro to identify Cdc13 spots that intersect with Sid4-mRFP spots
//always change these to match ROIset
//always load SPB into ROI manager before Cell - they will both need to be loaded into the same ROI manager
//In the code, assume Cell means Cdc13 spot, SPB means Sid4-mRFP mask
spbCount = 680;
cdc13spotCount = 531;


roiManager("List");

for (spb = 0 ; spb < spbCount ; spb++) {
	for (cdc13spot = spbCount ; cdc13spot < spbCount+cdc13spotCount ; cdc13spot++) {
		roiManager("select", spb);
		
		//get slice information
		SPBt = getResult("T", spb);
		SPBlabel = Roi.getName();
		roiManager("select", cdc13spot);
		Cdc13t = getResult("T", cdc13spot);
		Cdc13label = Roi.getName();
	
		//if SPB t frame is less than Cdc13spot frame, we've gone too far so stop the code. 
		//If it is more, we want to keep going, so continue means to go back through the code again. 
		//If neither are satistfied, it'll keep going forward
		if (SPBt < Cdc13t) {
			break;
		}
		if (SPBt > Cdc13t) {
			continue;
		}
		//check for intersection and print results
		roiManager('select', newArray(spb, cdc13spot));
		roiManager("AND");
		if (selectionType > -1) {
			print("SPB,",SPBlabel,",Cdc13spot,", Cdc13label, ",intersect");
			break;
		}
	}
}
