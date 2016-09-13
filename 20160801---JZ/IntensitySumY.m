function e = IntenSumY(img);

% This is the main function,calculating intensity fraction,
% background intensity per pixel and fiber intensity per pixel 
% Input img_A string or matrix read from IMREAD function.

if (ischar(img))
    img = imread(img);   %imread is to read image into the function
end

figure, imshow(img);

grey_img = rgb2gray(img);  %change rgb to uint8 gray image

%grey_img = img;

a=size(grey_img);
 
%clean z position
for x=500:1024
    for y=1:69
        if grey_img(x,y)~=226;
            continue
        else
            grey_img(x,y)=0;
        end
    end
end

%replace the center spot by the upper-left corner
%size of center matrix is subject to modification
rx=round(a(1)/2);
cy=round(a(2)/2);
xcount=1;
for r=(rx-110):(rx+140)
    xcount=xcount+1;
    ycount=1;
    for c=(cy-100):(cy+240)
        ycount=ycount+1;
        grey_img(r,c)=grey_img(xcount,ycount);
    end
end

%replace bottom left corner where it normally says "Z Position"
for r=(rx+495):(rx+512)
    xcount=xcount+1;
    ycount=1;
    for c=(cy-511):(cy-100)
        ycount=ycount+1;
        grey_img(r,c)=grey_img(xcount,ycount);
    end
end

%sum up intensities of all pixels
SumTotal=sum(grey_img(:))

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
 IntensityFraction=count/n  
 BackgroundPerPixel=SumBackground/(n*(1-IntensityFraction))
 SignalPerPixel=SumAbove/(n*IntensityFraction)
 
figure, imshow(grey_img);

% Saves thresholded image with spot replaced

imwrite(grey_img,'sample.tif','tif');

return;