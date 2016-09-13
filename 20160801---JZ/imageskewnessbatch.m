function e = imageskewnessbatch;

% will save the file skewness.txt to whatever directory you are in.

% first, you have to find the folder
folder = uigetdir; % check the help for uigetdir to see how to specify a starting path

% get the names of all files. dirListing is a struct array.
dirListing = dir(folder);

% loop through the files and open. Note that dir also lists the
% directories, so you have to check for them.
% only select files that are images.  don't know how to do this, so see
% below

fid = fopen('skewness.txt','wt');
fprintf(fid, 'File name\tSkewness \n');

for d = 1:length(dirListing)
    
    if dirListing(d).bytes  >= 15000 %for 1024 by 1024 images...so only opens these files
        fileName = fullfile(folder,dirListing(d).name); % use full path because the folder may not be the active path

        img = imread(fileName);  
        grey_img = double(img);  % grey image
        a = size(grey_img);

        columnl = a(1,1) * a(1,2);
        columnimage = reshape(grey_img,columnl,1);
        f = dirListing(d).name;
        e = skewness(columnimage);

        fprintf(fid, '%s\t%6.4f \n', f, e);

    end % if
end % for-loop

fclose(fid); 
