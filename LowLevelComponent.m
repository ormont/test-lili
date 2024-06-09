function out = LowLevelComponent(in,sigma)


% Input sizes
in                  = double(in);
imaggeSize          = size(in);
channels 	        = size(imaggeSize);
inputImageChannels  = channels(2);
channels		    = channels(2);
rows			    = imaggeSize(1);
cols 			    = imaggeSize(2);

if channels  == 2
   channels =1;
else 
   if channels == 3
      channels = imaggeSize (3);
   else
      return;
   end
end

x = ones(rows,1) * (-cols/2 : (cols/2 - 1));  
y = (-rows/2 : (rows/2 - 1))' * ones(1,cols);
radius = sqrt(x.^2 + y.^2);      
radius(round(rows/2+1),round(cols/2+1)) = 1;
clear x;clear y;

gauss = zeros(rows,cols);
gauss = exp((-(log(radius)).^2) / (2 * (sigma) ^2));
clear radius;

out = in;

for i=1:channels
    tmpIm = fft2(in);
    tmpIm(1) = 0;
    out(:,:,i) = ifft2(fftshift(tmpIm).*gauss);
end

clear gauss;