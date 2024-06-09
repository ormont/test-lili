function output = mGabor(inImage,outputMethod,nscale,norient)
% =========================================================================
% =========================================================================
% =========================================================================
[rows,cols,chans] = size(inImage);

[B,rLog,cLog,rMin,rMax,cMin,cMax] = reflectImage2N(inImage,0);

Tnyq = min(floor(size(inImage)/2));
nscale= max(min(nscale,floor(log(Tnyq)/log(2))-1),1);
N = max(size(inImage));
sigma = max(log(N/Tnyq + 1),0.001);
output = zeros(rLog,cLog,nscale*norient+1);

if outputMethod == 1
    output(:,:,1) = output(:,:,1) +  abs(LowLevelComponent(B,sigma));
else 
    if outputMethod == 2
        output(:,:,1) = output(:,:,1) +  real(LowLevelComponent(B,sigma));
    else
        if outputMethod == 3
            output(:,:,1) = output(:,:,1) + image(LowLevelComponent(B,sigma));
        else
            output(:,:,1) = output(:,:,1) + LowLevelComponent(B,sigma);
        end
    end
end
output(:,:,1) = max(output(:,:,1),1);

% Gabor responses %
j = 2;    
Tmax = Tnyq;
Tmin = 2^(nscale+1);
for i=1:nscale
   tt = GaborFeatures(B,outputMethod,norient,Tmax,Tmin,0);
   output(:,:,j:(j+norient-1)) = tt(:,:,1:norient);
   j = j + norient;
   Tmax = Tmin;
   Tmin = Tmin/2;
end

clear B;
clear tt;

output = output(rMin:rMax,cMin:cMax,:);
output = output;
% =========================================================================
% =========================================================================
% =========================================================================
function out = LowLevelComponent(in,sigma)

% Input sizes
in                  = double(in);
[rows,cols,channels] = size(in);
inputImageChannels  = channels;

x = ones(rows,1) * (-cols/2 : (cols/2 - 1));  
y = (-rows/2 : (rows/2 - 1))' * ones(1,cols);
radius = sqrt(x.^2 + y.^2);      
radius(round(rows/2+1),round(cols/2+1)) = 1;
clear x;clear y;

gauss = zeros(rows,cols);
gauss = exp((-(log(radius)).^2) / (2 * (sigma) ^2));
clear radius;

out = in;

tmpIm       = fft2(in);
tmpIm(1)    = 0;
out         = ifft2(fftshift(tmpIm).*gauss);

clear gauss;
% =========================================================================
% =========================================================================
% =========================================================================
function output = GaborFeatures(inImage,outputMethod,norient,Tmax,Tmin,minBW)

% Input sizes
inputImage           = double(inImage);
[rows,cols,channels] = size(inputImage);

% Pre-compute some stuff to speed up filter construction
N 	 = min(rows,cols);
Tmax = min(Tmax,N);
Tmin = max(Tmin,4);

Fmatlab_max = log(N/Tmin + 1);
Fmatlab_min = log(N/Tmax + 1);


if Fmatlab_max == Fmatlab_min 
    if minBW == 0
        minBWScale = Tmax/N;
    else
        minBWScale = minBW;
    end
else            
    if minBW == 0
        minBWScale = (Fmatlab_max-Fmatlab_min)/2;
    else
        minBWScale = minBW;
    end
end

% Output prep.
imagefft = fft2(inputImage); 
imagefft(1) = 0;
output = zeros(rows,cols,norient);

% Gabor Transform
x = ones(rows,1) * (-cols/2 : (cols/2 - 1));  
y = (-rows/2 : (rows/2 - 1))' * ones(1,cols);
radius = sqrt(x.^2 + y.^2);      
radius(round(rows/2+1),round(cols/2+1)) = 1; 
theta = atan2(-y,x);             
sintheta = sin(theta);
costheta = cos(theta);
clear x; clear y; clear theta; 

thetaSigma = pi/(2 * norient);  
for o = 1:norient,                  
    angl = (o-1) * pi/(norient);    
    
    ds = sintheta * cos(angl) - costheta * sin(angl);     
    dc = costheta * cos(angl) + sintheta * sin(angl);     
    dtheta = abs(atan2(ds,dc));                           
    clear dc; clear ds;
    spread = exp((-dtheta.^2) / (2 * thetaSigma^2));      
    clear dtheta; 
          
   Fmatlab_center = Fmatlab_min + minBWScale;
   sigmaFmatlab   = minBWScale;
   
   logGabor = exp((-(log(radius)-Fmatlab_center).^2) / (2 * (sigmaFmatlab) ^2));  
   logGabor(round(rows/2+1),round(cols/2+1)) = 0; 
   
   if norient==1
       filter = fftshift(logGabor);
   else
       filter = fftshift(logGabor .* spread); 
   end
     
   if abs(outputMethod) == 2 
       tempOut = real(ifft2(imagefft .* filter));    
   elseif abs(outputMethod) == 3
       tempOut  = imag(ifft2(imagefft .* filter));
   elseif abs(outputMethod) == 1 
       tempOut  = abs(ifft2(imagefft .* filter));
   else
       tempOut = ifft2(imagefft .* filter);
   end
   
   output(:,:,o) = tempOut;		   
   clear logGabor;
   clear filter;
   clear tempOut;
   clear spread;	
end	 
clear imagefft;  
clear radius;clear sintheta;clear costheta;clear thetaSigma; 