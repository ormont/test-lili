function [output,Gabors,Dom] = ComplexGaborFeaturesVI(inImage,outputMethod,nscale,norient,Tmax,Tmin,minBW)

% Input sizes
inputImage          = double(inImage);
imaggeSize          = size(inputImage);
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

% Pre-compute some stuff to speed up filter construction
N 	 = min(rows,cols);
Tmax = min(Tmax,N);
Tmin = max(Tmin,4);

Fmatlab_max = log(N/Tmin + 1);
Fmatlab_min = log(N/Tmax + 1);

if Fmatlab_max == Fmatlab_min | nscale == 1;
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
    nscale = 1;
else
     testBW = abs(Fmatlab_max -Fmatlab_min)/(2*nscale);
    if testBW < minBW
        minBWScale = minBW;
        nscale = floor(abs(Fmatlab_max -Fmatlab_min)/(2*minBW));
        if nscale < 1
            nscale = 1;
        else
            minBWScale = abs(Fmatlab_max -Fmatlab_min)/(2*nscale);
        end
    else
        minBWScale = testBW;
    end
end

% Output prep.
outChannels = 0;
startChan   = 1;
outChannels = outChannels + nscale*norient*channels;
output = zeros(rows,cols,outChannels );

Gabors  = zeros(rows,cols,nscale*norient);
Dom     = zeros(nscale*norient,6);

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
curChanOutput = startChan;  
curChanGabor =  1;
for o = 1:norient,                  
   angl = (o-1) * pi/(norient);    
   
   ds = sintheta * cos(angl) - costheta * sin(angl);     
   dc = costheta * cos(angl) + sintheta * sin(angl);     
   dtheta = abs(atan2(ds,dc));                           
   clear dc; clear ds;
   spread = exp((-dtheta.^2) / (2 * thetaSigma^2));      
   clear dtheta; 
   
   for s = 1:nscale           
    Fmatlab_center = Fmatlab_min + (2*s-1)*minBWScale;
    sigmaFmatlab   = minBWScale;
                  
      logGabor = exp((-(log(radius)-Fmatlab_center).^2) / (2 * (sigmaFmatlab) ^2));  
      logGabor(round(rows/2+1),round(cols/2+1)) = 0; 
      curChanGabor = 1+(s-1) + (o-1)*nscale;   
      
      if norient==1
          filter = fftshift(logGabor);
          Gabors(:,:,curChanGabor)=logGabor;
      else
          filter = fftshift(logGabor .* spread); 
          Gabors(:,:,curChanGabor)=logGabor .* spread;  
      end
      
      Dom(curChanGabor,1)= angl*180/pi;
      Dom(curChanGabor,2)= N/(exp(Fmatlab_center)-1);
      Dom(curChanGabor,3)= sigmaFmatlab;
      curT = N/(exp(Fmatlab_center-sigmaFmatlab)-1)-N/(exp(Fmatlab_center+sigmaFmatlab)-1);
      Dom(curChanGabor,4)= Dom(curChanGabor,2)+curT/2;
      Dom(curChanGabor,5)= Dom(curChanGabor,2)-curT/2;
      Dom(curChanGabor,6)= 0;
         
      for chan = 1:channels
           input = inputImage(:,:,chan);
           imagefft = fft2(input); 
           imagefft(1) = 0;
           clear input;
           
           if abs(outputMethod) == 2 
              tempOut = real(ifft2(imagefft .* filter));    
           else 
              if abs(outputMethod) == 3
                 tempOut  = imag(ifft2(imagefft .* filter));
              else 
                  if abs(outputMethod) == 1 
                      tempOut  = abs(ifft2(imagefft .* filter));
                  else
                      tempOut = ifft2(imagefft .* filter);
                  end
              end
          end
                    
           curChanOutput  = startChan + (s-1) + (o-1)*nscale + (chan-1)*norient*nscale;   
           output(:,:,curChanOutput) = tempOut;		
           
           Dom(curChanGabor,6) = max(Dom(curChanGabor,6),sum(sum(tempOut,1),2)/(rows*cols));
          
        end
        
        clear logGabor;
        clear filter;
        clear tempOut;
     end
     clear spread;	
end	 
clear imagefft;  
clear radius;clear sintheta;clear costheta;clear thetaSigma; 