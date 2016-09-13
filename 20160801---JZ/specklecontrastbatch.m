function e = imagespecklecontrastbatch;

% first, you have to find the folder
folder = uigetdir; % check the help for uigetdir to see how to specify a starting path, which makes your life easier

% get the names of all files. dirListing is a struct array.
dirListing = dir(folder);

% loop through the files and open.
fid = fopen('video8_lightchannel_threshold0_specklecontrast_jump64.txt','wt');

%for d=1:2;
for d = 1:length(dirListing)
    if dirListing(d).bytes  > 15000  %for 1024 by 1024 images...so only opens these files
fileName = fullfile(folder,dirListing(d).name); % use full path because the folder may not be the active path

grey_img = imread(fileName);  
a=size(grey_img);

%optional threshhold
minIntensity=0; % theshold subject to change
maxIntensity=255;
for x=1:a(1)
    for y=1:a(2)
        if  grey_img(x,y)<minIntensity; 
            grey_img(x,y)=1; %zero for most threshold things, but don't want undefined values here.
        end
    end
end

%speckle contrast
a1=1;
a2=1;
count=1;
jump = 64;

while a1 < a(1)
    while a2 < a(2)
        partialimg=double(grey_img(a1:a1+jump-1,a2:a2+jump-1));
        ap=size(partialimg);
        columnl=ap(1)*ap(2);
        columnimage=reshape(partialimg,columnl,1);
        av=mean(columnimage);
        stdev=std(columnimage);
        speckle(count)=stdev/av;
        a2=a2+jump;
        count=count+1;
    end
a1=a1+jump;
a2=1;
end 
    
speckleaverage=mean(speckle);

f=dirListing(d).name;


fprintf(fid, '%6.4f,     %s \n', speckleaverage, f);
end
end % for-loop
fprintf(fid,  'jump %6.4f ', jump);
fclose(fid); 
