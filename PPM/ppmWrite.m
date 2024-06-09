function ppmWrite(filename,method,inputImage)
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
if strcmp(method,'P5')==1 & channels~=1
    method = 'P6';
end

if  strcmp(method,'P6')==1 & channels==1
    method = 'P5';
else
    if  strcmp(method,'P6')==1 & channels~=3
        method = 'P7';
    end
end

if  strcmp(method,'P5')==1 |  strcmp(method,'P6')==1 |  strcmp(method,'P7')==1
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
FID = fopen(filename,'wb');
if FID == -1
   return;
end
fprintf(FID,'%s\n',method);
fprintf(FID,'#%03d 0\n',channels);
fprintf(FID,'#Created with Matlab\n');
fprintf(FID,'%d %d 255\n',cols,rows);

if  strcmp(method,'P6')==1
    tmp1 = zeros(channels,cols,rows);
    for c=1:channels
        tmp2 = flipud(rot90(inputImage(:,:,c)));
        tmp1(c,:,:) = tmp2;
    end
    tmp1 = reshape(tmp1,channels*cols*rows,1);
    fwrite(FID,tmp1,prec); 
else 
    tmp1 = zeros(cols,rows,channels);
    for c=1:channels 
        tmp1(:,:,c) = flipud(rot90(inputImage(:,:,c)));
    end
    tmp1 = reshape(tmp1,cols*rows*channels,1);
    fwrite(FID,tmp1,prec); 
end

clear tmp1 tmp2;
fclose(FID);