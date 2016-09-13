function e = crop2channels;

% Choose folder to get file from
inputDir = uigetdir;

% Choose folder to write files to (must make folder first!)
outputDirCFM = uigetdir;

outputDirCRM = uigetdir;

dirListing = dir(inputDir);

for d=1:length(dirListing)

    fileName = fullfile(inputDir,dirListing(d).name);
    
    % Splits up file name into pathstr, name, and extension
    
    [pathstr,name,ext] = fileparts(fileName);
    
    if dirListing(d).bytes >= 50000 % picks up all files above this size in bytes
        
        img = imread(fileName);
        
        croppedCFM = img(1:1024,1:1024);
        
        newNameCFM = fullfile(outputDirCFM,[name '_CRM.tif']);
        
        imwrite(croppedCFM, newNameCFM, 'tif');
        
        croppedCRM = img(1:1024,1027:2050);
        
        newNameCRM = fullfile(outputDirCRM,[name '_CTM.tif']);
        
        imwrite(croppedCRM, newNameCRM, 'tif');
        
    end
end

return;