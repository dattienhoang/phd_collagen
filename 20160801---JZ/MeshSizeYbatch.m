function e = MeshSizeYbatch;

% This is the main function, computing the mesh size revised by Yali
% batch written by Laura 06/10

% Input img_A string or matrix read from IMREAD function.

% first, you have to find the folder
folder = uigetdir; % check the help for uigetdir to see how to specify a starting path, which makes your life easier

% get the names of all files. dirListing is a struct array.
dirListing = dir(folder);

% loop through the files and open. Note that dir also lists the
% directories, so you have to check for them.
%only select files that are images.  don't know how to do this, so see
%below
fid = fopen('AS22-1230m-poresize_1101.txt','wt');

for d = 1:length(dirListing)
    if dirListing(d).bytes  >= 30000  %for 1024 by 1024 images...so only opens these files
fileName = fullfile(folder,dirListing(d).name); % use full path because the folder may not be the active path

img = imread(fileName);  
% grey_img=rgb2gray(img);  % change rgb to uint8 gray image
grey_img = img;
a=size(grey_img);

%clean ZPosition
for x=1010:1021
    for y=1:69
        if grey_img(x,y)~=226
            continue
        else            
            grey_img(x,y)=0;
        end
    end
end

 %THRESHHOLD BELOW
 %get rid of the dark background by threshholding (was set to 32 when ljk
 %received code upon Yali finishing thesis
 minIntensity=707; % theshold subject to change
 %maxIntensity=255;
 for x=1:a(1)
  for y=1:a(2)
      if  grey_img(x,y)<minIntensity; 
          grey_img(x,y)=0;
      end
  end
 end
%figure,imshow(grey_img);
%title('GreyImageThreshold');

 MinimumGap=1;
 DistributionOfY=zeros(1,a(1));
 DistributionOfX=zeros(1,a(2));
 a(3)=max(a(1),a(2));
 DistributionOfXY=zeros(1,a(3));
 
% get the X-axis distribution
   MaxX=0;
   for x=1:a(1)
     LastSpot=0; 
     for y=1:a(2)
       if grey_img(x,y)>0 & y-LastSpot>MinimumGap;
           DistributionOfX(1,y-LastSpot)=DistributionOfX(1,y-LastSpot)+1;
           if y-LastSpot>MaxX
             MaxX=y-LastSpot;
           end
       end
       if grey_img(x,y)>0
           LastSpot=y;
       end    
     end
   end
   
%get nonzero Distribution DX
MeshX=zeros(1,MaxX);
DX=zeros(1,MaxX);
r=0;
for x=1:MaxX
    if DistributionOfX(1,x)>0
       r=r+1;
       MeshX(1,r)=r;
       DX(1,r)=DistributionOfX(1,x);
    end
end


% MeshSize X distribution
 x=1:r;
 y=DX(1,x);
 fit=polyfit(x,log(y),1);
 fitx=fit(1);
   
% get the Y-axis distribution
   MaxY=0;
   for y=1:a(2)
     LastSpot=0;
     for x=1:a(1)
       if grey_img(x,y)>0 & x-LastSpot>MinimumGap;
           DistributionOfY(1,x-LastSpot)=DistributionOfY(1,x-LastSpot)+1;
           if x-LastSpot>MaxY
             MaxY=x-LastSpot;
           end
       end
       if grey_img(x,y)>0
           LastSpot=x;
       end      
     end
   end
   
% get nonzero Distribution DY
MeshY=zeros(1,MaxY);
DY=zeros(1,MaxY);
r=0;
for x=1:MaxY
    if DistributionOfY(1,x)>0
       r=r+1;
       MeshY(1,r)=r;
       DY(1,r)=DistributionOfY(1,x);
    end
end


% MeshSize Y distribution
 x=1:r;
 y=DY(1,x);
 fit=polyfit(x,log(y),1);
 fity=fit(1);
 
% MeshSize XY distribution
 if MaxX<=MaxY;
    MaxXY=MaxY;
    for x=1:MaxX
    DistributionOfXY(x)=DistributionOfX(x)+DistributionOfY(x);
    for x=(MaxX+1):MaxXY
    DistributionOfXY(x)=DistributionOfY(x);
    end
    end
 else
    MaxXY=MaxX;
    for x=1:MaxY
    DistributionOfXY(x)=DistributionOfX(x)+DistributionOfY(x);
    for x=(MaxY+1):MaxXY
    DistributionOfXY(x)=DistributionOfX(x);
    end
    end
 end
 
% get nonzero Distribution DXY
MeshXY=zeros(1,MaxXY);
DXY=zeros(1,MaxXY);
r=0;
for x=1:MaxXY
    if DistributionOfXY(1,x)>0
       r=r+1;
       MeshXY(1,r)=r;
       DXY(1,r)=DistributionOfXY(1,x);
    end
end


% MeshSize XY distribution
% figure;
% axis([1 r 0 max(DXY)]); 
x=1:r;
y=DXY(1,x);
fit=polyfit(x(6:r),log(y(6:r)),1); %fitting range is subject to modification
%semilogy(x,y,'o',x,exp(fit(2)).*exp(fit(1)*x));  %plot # of findings vs. MeshSizes
%xlabel('Distance[pixel]');
%ylabel('#');
%title('DistributionInXY');
fitxy=fit(1);
meshsize=-0.229/fit(1);  %convert pixel to um

 f=dirListing(d).name;


fprintf(fid, '%6.4f     %s \n', meshsize, f);
end
end % for-loop
fprintf(fid,  'threshhold %6.4f   first fit point %s',minIntensity, '6' );
fclose(fid); 
