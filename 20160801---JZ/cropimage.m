function e = cropimage;

% Choose folder to get file from
inputDir = uigetdir;

% Choose folder to write files to (must make folder first!)
outputDir = uigetdir;

dirListing = dir(inputDir);

for d=1:length(dirListing)

    fileName = fullfile(inputDir,dirListing(d).name);
    
    % Splits up file name into pathstr, name, and extension
    
    [pathstr,name,ext] = fileparts(fileName);
    
    if dirListing(d).bytes >= 50000 % picks up all files above this size in bytes
        
        img = imread(fileName);
        
        cropped = img(1:1024,1:1024);
        
        newName = fullfile(outputDir,[name '_cropped.tif']);
        
        imwrite(cropped, newName, 'tif');
                
    end
end

return;