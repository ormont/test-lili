function [out,sc,err] = ppmReadAppendImage(filename,imageNumber,channelsPerImage)

out = 0;
err = 0;

FID = fopen(filename,'rb');

if FID == -1
   err = 1;
   return;
end
   
newline = sprintf('\n'); 
 
p = fscanf(FID,'%c',1);
if p ~= 'p' & p~='P'
    err = 2;
  	fclose(FID);
   return;
end

type = fscanf(FID,'%d',1);
if type < 5 | type > 10
    err = 3;
	fclose(FID);
   return
end

if type == 5 % GreyLevel Char %
   channels 	= 1;
   interleaved = 0;
   prec = 'uchar';
   precValue = 1;
end

if type == 6 % Color Char %
   channels 	= 3;
   interleaved = 1;
   prec = 'uchar';
   precValue = 1;
end

if type == 7 % Multichannel Char %
	p = fscanf(FID,'%c',1);		
	while p ~= '#'
		p = fscanf(FID,'%c',1);
	end
	fseek(FID,-1,'cof');
   tmp = fscanf(FID,'#%d %d',2);
   channels = tmp(1);
   interleaved  = tmp(2);
   prec = 'uchar';
   precValue = 1;
end

if type == 8 % Multichannel INT %
	p = fscanf(FID,'%c',1);		
	while p ~= '#'
		p = fscanf(FID,'%c',1);
	end
	fseek(FID,-1,'cof');
   tmp = fscanf(FID,'#%d %d',2);
   channels = tmp(1);
   interleaved  = tmp(2);
   prec = 'int32';
   precValue = 4;
end

if type == 9 % Multichannel FLOAT %
	p = fscanf(FID,'%c',1);		
	while p ~= '#'
		p = fscanf(FID,'%c',1);
	end
	fseek(FID,-1,'cof');
   tmp = fscanf(FID,'#%d %d',2);
   channels = tmp(1);
   interleaved  = tmp(2);
   prec = 'float32';
   precValue = 4;
end

if type == 10 % Multichannel DOUBLE %
	p = fscanf(FID,'%c',1);		
	while p ~= '#'
		p = fscanf(FID,'%c',1);
	end
	fseek(FID,-1,'cof');
   tmp = fscanf(FID,'#%d %d',2);
   channels = tmp(1);
   interleaved  = tmp(2);
   prec = 'double';
   precValue = 8;
end
% Read the rest of the header 
p = fscanf(FID,'%c',1);	
if p==newline
    p = fscanf(FID,'%c',1);	
end

while p == '#'
   q = fscanf(FID,'%c',1);
	while q ~= newline 
		q = fscanf(FID,'%c',1);				
	end
	p = fscanf(FID,'%c',1);
end
fseek(FID,-1,'cof');
% Read the image size
tmp =	fscanf(FID,'%d %d %d',3);
cols = tmp(1);
rows = tmp(2);
% Check image size 
if rows <= 0 | cols <= 0 | channels <= 0
   fclose(FID);
   return
end
% Go to the data 	
p = fscanf(FID,'%c',1);
while p ~= newline 		
   p = fscanf(FID,'%c',1);
end

sc = channels/channelsPerImage;
if sc < 1 
    err = 'Invalid amount of channels';
    return;
end
out = zeros(rows,cols,channelsPerImage);
% Seek the position:
posToGo = (imageNumber-1)*channelsPerImage*rows*cols*precValue;
fseek(FID,posToGo,'cof');

% Read the data
tmp = fread(FID,channelsPerImage*rows*cols,prec );
% CHAR IMAGES 

tmp1 = reshape(tmp,[cols rows channelsPerImage]);
clear tmp;
for c=1:channelsPerImage
   out(:,:,c) = flipud(rot90(tmp1(:,:,c)));;
end
clear tmp1;
     
fclose(FID);