function ppmWriteAppend(filename,method,inputImage)
% ppmWrite(filename,method,inputImage)
% methods: 
%   - P5  1-channel uchar 
%   - P6  3-channel uchar 
%   - P7  N-channel uchar 
%   - P8  N-channel int32
%   - P9  N-channel float32
%   - P10 N-channel double

% Input Image specs
[rows,cols,channels] = size(inputImage);

% Method correction
if strcmp(method,'P5')==1  | strcmp(method,'P6')==1
    method = 'P7';
end

if  strcmp(method,'P7')==1
    prec = 'uchar';
else 
    if strcmp(method,'P8')==1 
        prec = 'int32';
    else
        if strcmp(method,'P9')==1 
            prec = 'float32';
        else
            if strcmp(method,'P10')==1
                prec = 'double';
            else
                return
            end            
        end
    end
end

% Printing
newChannels = getChannels(filename,method)+channels;
FID = fopen(filename,'r+');
if FID == -1
    FID = fopen(filename,'w+');
        
    if FID == -1
        return;
    end
    fprintf(FID,'%s\n',method);
    fprintf(FID,'#%03d 0\n',newChannels);
    fprintf(FID,'#Created with Matlab\n');
    fprintf(FID,'%d %d 255\n',cols,rows);
else
    fseek(FID,0,'bof');
    fprintf(FID,'%s\n',method);
    fprintf(FID,'#%03d 0\n',newChannels);
    fprintf(FID,'#Created with Matlab\n');
    fprintf(FID,'%d %d 255\n',cols,rows);
    fseek(FID,0,'eof');
end
tmp1 = zeros(cols,rows,channels);
for c=1:channels 
    tmp1(:,:,c) = flipud(rot90(inputImage(:,:,c)));
end
tmp1 = reshape(tmp1,cols*rows*channels,1);
fwrite(FID,tmp1,prec); 

clear tmp1;
fclose(FID);
% =========================================================================
% =========================================================================
% =========================================================================
function newChannels = getChannels(filename,method);

newChannels = 0;

% file exists
FID = fopen(filename,'rb');
if FID == -1
   return;
end

% valid ppm-file
p = fscanf(FID,'%c',1);
if p ~= 'p' & p~='P'
  	fclose(FID);    
    return;
end

% type > 6 and not interleaved
type = fscanf(FID,'%d',1);
p = fscanf(FID,'%c',1);		
while p ~= '#'
	p = fscanf(FID,'%c',1);
end
fseek(FID,-1,'cof');
tmp = fscanf(FID,'#%d %d',2);
newChannels  = tmp(1);
interleaved  = tmp(2);
fclose(FID);

% method check 
pMethod = sscanf(method(2:end),'%d');
if type<7 | interleaved==1 | pMethod~= type
    A = ppmRead(filename);
    ppmwrite(filename,method,A);
    clear A;
end
