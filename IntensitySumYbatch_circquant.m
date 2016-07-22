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

fid = fopen('OF_CFM_Mag_1rads_S1-042616.csv','wt');
fprintf(fid,  'FileName,\tSumTotal\n\n%s');

%fprintf(fid,  'FileName\tTime (min)\tSumTotal\tSumAboveThreshhold\tIntensityFraction \n\n%s');

%countTime = -0.5;  
    
for d = 1:length(dirListing)

    if dirListing(d).bytes >= 500000 % this ignores any "hidden" files 
        % in the folder that are not image files of size at least 
        % larger than this size  
        
fileName = fullfile(folder,dirListing(d).name);

img = imread(fileName); 

%grey_img = rgb2gray(img);

grey_img = img;

a=size(grey_img);

%replace the center spot by the upper-left corner
%size of center matrix is subject to modification
    rx=round(a(1)/2);
    cy=round(a(2)/2);
    xcount=1;
    for r=(rx-140):(rx+160)
        xcount=xcount+1;
        ycount=1;
        for c=(cy-150):(cy+240)
            ycount=ycount+1;
            grey_img(r,c)=grey_img(xcount,ycount);
        end
    end

    
%sum up intensities of all pixels
%this is the value for one frame...
% convert to radians
grey_img_rad = grey_img * 0.0174533
c_bar =  sum(cos(grey_img_rad)) / (a[0] * a[1])
s_bar =  sum(sin(grey_img_rad)) / (a[0] * a[1])
r_bar = sqrt(c_bar^2 + s_bar^2)
% calculate mean angle
% atan2 should keep it real and
theta_bar = atan2(s_bar, c_bar)

SumTotal = theta_bar
DevTotal = 1 - r_bar

%SumTotal=sum(grey_img(:));
%DevTotal=std2(grey_img(:));

%find threshold and calculate IF and intensity sum of fiber pixels
minIntensity = 0; %thresholding the image
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

%countTime = countTime + 0.5; 

f=dirListing(d).name;

%Saves thresholded image with spot replaced
[pathstr,name,ext] = fileparts(fileName);

newFolder = fullfile(outputDir, [name '_rs.tif' ]);

imwrite(grey_img, newFolder,'tif');

%fprintf(fid, '%s      , %f,  %6.4f,   %6.4f,  %6.4f \n', f, countTime, SumTotal, SumAbove, IntensityFraction);

fprintf(fid, '%s      , %6.4f, %6.4f\n', f, SumTotal, DevTotal);

    end % end if-loop  
    
end % end for-loop

%fprintf(fid,  '\n\nthreshold %6.4f', minIntensity);
fclose(fid); 

return;