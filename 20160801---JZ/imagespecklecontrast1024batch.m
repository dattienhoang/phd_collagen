function e = imagespecklecontrastbatch;

% first, you have to find the folder
folder = uigetdir; % check the help for uigetdir to see how to specify a starting path, which makes your life easier

% get the names of all files. dirListing is a struct array.
dirListing = dir(folder);

% loop through the files and open. Note that dir also lists the
% directories, so you have to check for them.
%only select files that are images.  don't know how to do this, so see
%below

fid = fopen('specklecontrast1024.txt','wt');

%for d=3:5;
for d = 1:length(dirListing)
    if dirListing(d).bytes  == 3150028  %for 1024 by 1024 images...so only opens these files
fileName = fullfile(folder,dirListing(d).name); % use full path because the folder may not be the active path

img = imread(fileName);  
%figure(1),imshow(img);
%title('OriginalImage')
grey_img = double(rgb2gray(img));  % grey image
a=size(grey_img);

%optional replace the center spot by the upper-left corner
%size of center matrix is subject to modification; try out first to make
%sure it's in the right spot.
%rx=round(a(1)/2);
%cy=round(a(2)/2);
%xcount=1;
%for r=(rx-70):(rx+90)
%    xcount=xcount+1;
%    ycount=1;
%    for c=(cy-30):(cy+210)
 %       ycount=ycount+1;
%        grey_img(r,c)=grey_img(xcount,ycount);
%    end
%end

%optional threshhold
%get rid of the dark background by threshholding (was set to 32 when ljk
%received code upon Yali finishing thesis
 minIntensity=32; % theshold subject to change
 maxIntensity=255;
 for x=1:a(1)
  for y=1:a(2)
      if  grey_img(x,y)<minIntensity; 
          grey_img(x,y)=1; %zero for most threshold things, but don't want undefined values here.
      end
  end
 end
%figure(2),imshow(grey_img);
%title('GreyImageThreshold');

%easy speckle contrast
        columnl=a(1)*a(2);
        columnimage=reshape(grey_img,columnl,1);
        av=mean(columnimage);
        stdev=std(columnimage);
        speckle=stdev/av;
        

%figure(3),hist(speckle,30)
%figure(4),hist(specklenonzero,30)
%speckleaverage=speckle;

f=dirListing(d).name;


fprintf(fid, '%6.4f,     %s \n', speckle, f);
    end
end % for-loop
fprintf(fid,  'threshhold %6.4f ',minIntensity);
fclose(fid); 
