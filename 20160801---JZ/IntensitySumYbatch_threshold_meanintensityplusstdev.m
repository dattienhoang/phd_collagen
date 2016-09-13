function e = IntensitySumYbatch;

% This is the main function,calculating intensity fraction,
% background intensity per pixel and fiber intensity per pixel 
% Input img_A string or matrix read from IMREAD function.

% first, you have to find the folder
folder = uigetdir; % check the help for uigetdir to see how to specify a starting path, which makes your life easier

% folder to write new files to (must make folder first!)
outputDir = uigetdir;

% get the names of all files. dirListing is a struct array.
dirListing = dir(folder);

% loop through the files and open. Note that dir also lists the
% directories, so you have to check for them.
% only select files that are images.

fid = fopen('intensity.txt','wt');
fprintf(fid,  'FileName\tSumTotal\tSumAboveThreshhold\tIntensityFraction\tMeanIntensity\tMeanStandardDeviation\tThreshold \n\n%s');

for d = 1:length(dirListing)

    if dirListing(d).bytes >= 500000 % this ignores any "hidden" files 
        % in the folder that are not image files of size at least 
        % larger than this size
    
fileName = fullfile(folder,dirListing(d).name);

img = imread(fileName); 

%grey_img = rgb2gray(img);

grey_img = img;

a=size(grey_img);

% clean z position
 for x=500:1024
    for y=1:69
        if grey_img(x,y)~=226;
            continue
        else
            grey_img(x,y)=0;
        end
    end
 end

%sum up intensities of all pixels
SumTotal=sum(grey_img(:));

%reshape uint8 img matrix into a vector; then find the mean and stdev and
%use that to set threshold

B = reshape(grey_img,1,1048576);

C = mean(B);

D = std2(B);

E = C + D;

%find threshold and calculate IF and intensity sum of fiber pixels
minIntensity = E; %thresholding the image
count=0;
sum1=0;
    for y=1:a(2)
        for x=1:a(1)
            if grey_img(x,y)<= minIntensity;
            grey_img(x,y)=0;
            else
            sum1=sum1+double(grey_img(x,y));
            count=count+1;
            end
        end
    end
SumAbove=sum1;
SumBackground=SumTotal-SumAbove;
n=numel(grey_img);
IntensityFraction=count/n;  
BackgroundPerPixel=SumBackground/(n*(1-IntensityFraction));
SignalPerPixel=SumAbove/(n*IntensityFraction);
 
f=dirListing(d).name;

%Saves thresholded image with spot replaced
[pathstr,name,ext] = fileparts(fileName);

newFolder = fullfile(outputDir, [name '_thresholdmeanstdev.tif' ]);

imwrite(grey_img, newFolder,'tif');

fprintf(fid, '%s      , %6.4f,   %6.4f,  %6.4f,  %6.4f,  %6.4f,  %6.0f\n', f, SumTotal, SumAbove, IntensityFraction, C, D, minIntensity);

    end

end % for-loop

fclose(fid); 

return;