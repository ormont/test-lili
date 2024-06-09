function [out,err] = ppmRead(filename)

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
end

if type == 6 % Color Char %
   channels 	= 3;
   interleaved = 1;
   prec = 'uchar';
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

out = zeros(rows,cols,channels);

% Read the data
tmp = fread(FID,channels*rows*cols,prec );
% CHAR IMAGES 

i = 1;
if interleaved == 1
    tmp1 = reshape(tmp,[channels cols rows]);
    tmp2 = zeros(cols,rows,channels);
    for c=1:channels
        tmp2(:,:,c) = tmp1(c,:,:);
        out(:,:,c) = flipud(rot90(tmp2(:,:,c)));
    end
    clear tmp tmp1 tmp2;
else
   tmp1 = reshape(tmp,[cols rows channels]);
   for c=1:channels
      out(:,:,c) = flipud(rot90(tmp1(:,:,c)));;
   end
end
     
fclose(FID);
