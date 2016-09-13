function imagespecklecontrast(img);

grey_img=double(imread(img));  
a=size(grey_img);

%thresholding
minIntensity=0;
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
%fprintf(fid, '%s,  %s, %s\n', 'boxsize', 'speckleaverage', 'speckleaveragenonzero');

%try from 2 - 1024
a1=1;
a2=1;
count=1;
jump=4;
%while jump < 1029
    while a1 < a(1)
        while a2 < a(2)
            partialimg=grey_img(a1:a1+jump-1,a2:a2+jump-1);
            ap=size(partialimg); %gets size of new "box"
            columnl=ap(1)*ap(2); 
            columnimage=reshape(partialimg,columnl,1); %reshape into "box" into column with specified # rows
            av=mean(columnimage); %mean value
            stdev=std(columnimage); %stdev value
            speckle(count)=stdev/av; %stdev divided by av to give new speckle matrix
            a2=a2+jump;
            count=count+1;
        end 
    a1=a1+jump;
    a2=1;
    end 
    
    specklenonzero=nonzeros(speckle); %new column matrix of nonzero values from speckle matrix
    figure,hist(speckle,30)
    %figure,hist(specklenonzero,30)
    speckleaverage=mean(speckle) %mean value from speckle matrix
    speckleaveragenonzero=mean(specklenonzero) %mean value from specklenonzero matrix
    %a1=1; a2=1;
    %jump=jump*2
    %count=1;
    %clear speckle

    %columnl=(a(1)*a(2));
    %columnimage=reshape(grey_img,columnl,1);
    %av=mean(columnimage);
    %stdev=std(columnimage);
    %speckle=stdev/av

%fprintf(fid, '%6.4f,  %6.4f, %6.4f\n', jump/2, speckleaverage, speckleaveragenonzero);

%end % while loop with jump in it

%fprintf(fid, 'threshhold %6.4f', minIntensity)
%fclose(fid); 
