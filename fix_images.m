currentPos = 5;
max_frames = 27;

cellsToChange = dictionary();
cellsToChange(9) = {[
  % Between frame x and y change pixels a to b
  % x, y, a, b
  [1,1,2,3],
  [1,1,24,26],
  [2,3,28,26],
  [1,1,3,31],
  [1,1,15,33],
  [1,1,27,34],
  [2,5,25,34],
  [1,1,26,35],
  [1,1,28,36],
  [1,1,6,37],
  [2,3,8,37],
  [3,5,32,37],
  [1,1,8,38],
  [2,2,32,38],
  [3,3,37,38],
  [1,1,25,39],
  [2,3,34,39],
  [1,1,16,15]
]};

cellsToChange(8) = {[
  % Between frame x and y change pixels a to b
  % x, y, a, b
  [1,2,7,6],
  [1,1,17,16],
  [1,1,4,20],
  [2,3,5,20],
  [1,1,6,21],
  [1,1,16,23],
  [1,1,5,24],
  [2,2,20,24],
  [1,1,9,25],
  [2,3,10,25],
  [3,5,22,25],
  [1,1,10,26],
  [2,2,22,26],
  [3,3,25,26] 
]};

cellsToChange(7) = {[
  % Between frame x and y change pixels a to b
  % x, y, a, b
  [1,1,3,4],
  [2,3,5,4],
  [1,1,7,8],
  [1,1,11,12],
  [1,1,18,14],
  [1,1,14,17],
  [1,1,19,21],
  [2,4,16,21],
  [1,1,4,26],
  [1,1,5,27],
  [1,1,8,28],
  [1,1,12,29],
  [1,1,16,30],
  [1,1,17,31],
  [1,1,21,32],
  [1,1,23,33],
  [1,1,24,34]
]};

cellsToChange(6) = {[
  % Between frame x and y change pixels a to b
  % x, y, a, b
  [1,1,6,5],
  [1,1,8,9],
  [1,1,14,13],
  [1,1,17,18],
  [1,1,5,24],
  [1,1,9,25],
  [1,1,13,26],
  [1,1,18,27]
]};

cellsToChange(5) = {[
  % Between frame x and y change pixels a to b
  % x, y, a, b
  [2,6,21,2],
  [1,6,3,4],
  [2,6,22,11],
  [2,6,23,13],
  [2,6,13,15],
  [15,27,18,15],
  [2,6,24,17],
  [7,14,18,17],
  [2,6,25,20],
  [1,2,5,26],
  [2,6,2,26],
  [1,6,4,27],
  [1,6,7,28],
  [1,6,8,29],
  [2,6,11,30],
  [1,2,10,30],
  [1,6,12,31],
  [1,3,14,32],
  [2,6,15,32],
  [1,2,16,33],
  [2,6,18,33],
  [1,1,18,34],
  [2,6,17,34],
  [1,1,19,35],
  [2,6,20,35]
]};

trk_image_files = loadFiles();

for currentFrame = 1:max_frames
    imageData = imread(trk_image_files{currentFrame});
    update = imageData;
    changesAsCellType = cellsToChange(currentPos);
    changes = changesAsCellType{1}';

    for change = changes
        firstFrame = change(1);
        lastFrame = change(2);
        if currentFrame >= firstFrame && currentFrame <= lastFrame
            update = changePixels(imageData, update, change(3), change(4));
        end
    end
    
    newFilename = sprintf("trk-updated-%d.tif", currentFrame);
    imwrite(update, newFilename);
end

function [files] = loadFiles()
    trk_image_files = uigetfile('trk-Labelled.tif','Select tracked images', 'Multiselect','on');
    files = trk_image_files';
end

function newImage = changePixels(original_image, image, oldValue, newValue)
    imgValues = original_image(:,:);
    pixelsThatMatchOldValue = (imgValues == oldValue);
    image(pixelsThatMatchOldValue) = newValue;
    newImage = image;
end


