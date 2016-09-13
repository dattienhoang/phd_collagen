function e = CleanUp(img);

% This is to clean up an image (take off scale bar, etc) for paper

% Input img_A string or matrix read from IMREAD function.

if (ischar(img))
    img = imread(img);  
end
figure,imshow(img);
title('OriginalImage');

%grey_img=rgb2gray(img);  % change rgb to uint8 gray image
%a=size(grey_img);
img=img(:,:,1);
a=size(img);

%clean  scalebar (usual position...below that is diff. position)
%for x=1010:1021
%     for y=1:69
%         if img(x,y)~=255
%            continue
%        else            
%            img(x,y)=0;
%        end
%    end
%end

for x=960:985
    for y=20:265
        if img(x,y)~=255
            continue
        else            
           img(x,y)=0;
        end
    end
end

%clean  Zposition
for x=1000:1024
    for y=1:75
        if img(x,y)~=255
            continue
        else            
            img(x,y)=0;
        end
    end
end

%replace the center spot by the upper-left corner
%size of center matrix is subject to modification
rx=round(a(1)/2);
cy=round(a(2)/2);
xcount=1;
for r=(rx-60):(rx+110)
    xcount=xcount+1;
    ycount=1;
    for c=(cy-15):(cy+155)
        ycount=ycount+1;
        img(r,c)=img(xcount,ycount);
    end
end

figure,imshow(img);
