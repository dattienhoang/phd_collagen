function e = MeshSizeYbatch;

% This is the main function, computing the mesh size revised by Yali
%batch written by Laura 06/10

% Input img_A string or matrix read from IMREAD function.

% first, you have to find the folder
folder = uigetdir; % check the help for uigetdir to see how to specify a starting path, which makes your life easier

% get the names of all files. dirListing is a struct array.
dirListing = dir(folder);

% loop through the files and open. Note that dir also lists the
% directories, so you have to check for them.
%only select files that are images.  don't know how to do this, so see
%below
fid = fopen('autothreshporesize.txt','wt');
%for d=3:5;
for d = 1:length(dirListing)
    if dirListing(d).bytes  == 3150028  %for 1024 by 1024 images...so only opens these files
fileName = fullfile(folder,dirListing(d).name); % use full path because the folder may not be the active path

img = imread(fileName);  

% This is the main function, computing the mesh size revised by Yali

% Input img_A string or matrix read from IMREAD function.


%clean ZPosition
for x=1010:1021
    for y=1:69
        if img(x,y)~=255;
            continue
        else            
            img(x,y)=0;
        end
    end
end

img1=img(:,:,1);  % don't change to gray b/c there saturation becomes 255/3 instead of 255
a=size(img1);


%replace the center spot by the upper-left corner
%size of center matrix is subject to modification
rx=round(a(1)/2);
cy=round(a(2)/2);
xcount=1;
for r=(rx-80):(rx+120)
    xcount=xcount+1;
    ycount=1;
    for c=(cy-60):(cy+200)
        ycount=ycount+1;
        img1(r,c)=img1(xcount,ycount);
    end
end

%averages
set=mean(mean(img1));
setmedian=median(median(img1));
imgline=img1(:);
imgu=unique(imgline);
n=histc(imgline,imgu);
[ix,ix]=max(n);
r=[n(ix),imgu(ix)];
setmode=r(2);


 %get rid of the dark background by threshholding (was set to 32 when ljk
 %received code upon Yali finishing thesis
 minIntensity=set*1.5 % theshold subject to change [this is best]
% minIntensity=setmedian*2.3 % theshold subject to change
% minIntensity=setmode*3.5 % theshold subject to change
 maxIntensity=255;
 for x=1:a(1)
  for y=1:a(2)
      if  img1(x,y)<minIntensity; 
          img1(x,y)=0;
      end
  end
 end

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
       if img1(x,y)>0 & y-LastSpot>MinimumGap;
           DistributionOfX(1,y-LastSpot)=DistributionOfX(1,y-LastSpot)+1;
           if y-LastSpot>MaxX
             MaxX=y-LastSpot;
           end
       end
       if img1(x,y)>0
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

%fid = fopen('DX.txt', 'wt');
%x=1:r; xx=[MeshX(1,x);DX(1,x)];
%fprintf(fid,'%4.0f %6.0f\n',xx);
%fclose(fid);

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
       if img1(x,y)>0 & x-LastSpot>MinimumGap;
           DistributionOfY(1,x-LastSpot)=DistributionOfY(1,x-LastSpot)+1;
           if x-LastSpot>MaxY
             MaxY=x-LastSpot;
           end
       end
       if img1(x,y)>0
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

%fid = fopen('DY.txt', 'wt');
%x=1:r; xx=[MeshY(1,x);DY(1,x)];
%fprintf(fid,'%4.0f %6.0f\n',xx);
%fclose(fid);

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

%fid = fopen('DXY.txt', 'wt');
%x=1:r; xx=[MeshXY(1,x);DXY(1,x)];
%fprintf(fid,'%4.0f %6.0f\n',xx);
%fclose(fid);

% MeshSize XY distribution
% figure;
% axis([1 r 0 max(DXY)]); 
 x=1:r;
y=DXY(1,x);
fit=polyfit(x(6:r),log(y(6:r)),1); %fitting range is subject to modification
% semilogy(x,y,'o',x,exp(fit(2)).*exp(fit(1)*x));  %plot # of findings vs. MeshSizes
% xlabel('Distance[pixel]');
% ylabel('#');
% title('DistributionInXY');
 fitxy=fit(1);
 meshsize=-0.2304/fit(1)  %convert pixel to um

%fid = fopen('fit.txt','wt');
%x=[fitx,fity,fitxy,meshsize];
%fprintf(fid,'%4.6f %4.6f %4.6f %4.6f\n',x);
%fclose(fid); 

f=dirListing(d).name;

fprintf(fid, '%6.4f     %6.4f   %s \n', minIntensity, meshsize, f);
end
end % for-loop
fprintf(fid, 'threshhold', 'meshsize', 'filename');
fclose(fid); 


      
return;