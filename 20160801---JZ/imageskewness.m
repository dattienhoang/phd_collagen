function e = imageskewness(img);

% This is for calculating skewness of an image.

% Input
% img   A string or matrix read from IMREAD function.

if (ischar(img))
    img = imread(img);  
end
grey_img = double(rgb2gray(img));  % grey image
a=size(grey_img);

columnl=a(1,1)*a(1,2);
columnimage=reshape(grey_img,columnl,1);
e=skewness(columnimage)

%30 is number of bins
hist(columnimage,30);


return;