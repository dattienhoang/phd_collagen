function e = imagespecklecontrast(img);

grey_img = imread(img);  
a=size(double(grey_img));

%thresholding
minIntensity=0;
maxIntensity=255;

for x=1:a(1)
 for y=1:a(2)
     if  grey_img(x,y)<minIntensity; 
         grey_img(x,y)=1;  %zero for most thresholded things, but don't want undefined values here.
     end
 end
end

%optional write file for when varying box size
%fid = fopen('specklecontrast.txt','wt');
%fprintf(fid, '%s\n', img)
%fprintf(fid, '%s,  %s, %s\n', 'boxside', 'speckleaverage', 'speckleaveragenonzero');

%try from 2 - 1024
a1=1;
a2=1;
count=1;
jump=2;
while jump < 1029
while a1 < a(1)
    while a2 < a(2)
        partialimg=grey_img(a1:a1+jump-1,a2:a2+jump-1);
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
    
specklenonzero=nonzeros(speckle);
%figure(3),hist(speckle,30)
%figure(4),hist(specklenonzero,30)
speckleaverage=mean(speckle);
speckleaveragenonzero=mean(specklenonzero);
a1=1; a2=1;
jump=jump*2
count=1
clear speckle

%columnl=(a(1)*a(2));
%columnimage=reshape(grey_img,columnl,1);
%av=mean(columnimage);
%stdev=std(columnimage);
%speckle=stdev/av

jump/2

speckleaverage

speckleaveragenonzero

%fprintf(fid, '%6.4f,  %6.4f, %6.4f\n', jump/2, speckleaverage, speckleaveragenonzero);

end % while loop with jump in it
%fprintf(fid, 'threshhold %6.4f', minIntensity)
%fclose(fid); 
