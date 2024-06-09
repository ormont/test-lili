function [output,Gabors,Dom] = GaborFinalB(inImage,outputMethod,nscale,norient)

imS = size(inImage);
if length(imS) == 3
    imS = imS(3);
else
    imS = 1;
end

newSize = 2^ceil(log(max(size(inImage)))/log(2));
Tnyq = max(floor(size(inImage)/2));
nscale= max(min(nscale,floor(log(Tnyq)/log(2))-1),1);
N = max(size(inImage));
sigma = max(log(N/Tnyq + 1),2);

output = zeros(newSize,newSize,nscale*norient+1);
Gabors  = zeros(newSize,newSize,nscale*norient);
Dom     = zeros(nscale*norient,6);

% LowLevel Component + resize
B = zeros(newSize,newSize,imS);
for i=1:imS
    [B(:,:,i),rMin,rMax,cMin,cMax] = mirrorImage(inImage(:,:,i),newSize);
    if outputMethod == 1
        output(:,:,1) = output(:,:,1) +  abs(LowLevelComponent(B(:,:,i),sigma));
    else 
        if outputMethod == 2
            output(:,:,1) = output(:,:,1) +  real(LowLevelComponent(B(:,:,i),sigma));
        else
            if outputMethod == 3
              output(:,:,1) = output(:,:,1) + image(LowLevelComponent(B(:,:,i),sigma));
            else
                output(:,:,1) = output(:,:,1) + LowLevelComponent(B(:,:,i),sigma);
            end
        end
    end
end

% Gabor responses %
j = 2;    
Tmax = Tnyq;
Tmin = 2^(nscale+1);
for i=1:nscale
   for l=1:imS
      [tt,GaborsTmp,DomTmp] = ComplexGaborFeaturesVI(B(:,:,l),outputMethod,1,norient,Tmax,Tmin,0);
      output(:,:,j:(j+norient-1)) = output(:,:,j:(j+norient-1)) + tt(:,:,1:norient);
   end
   Gabors(:,:,j:(j+norient-1)) = GaborsTmp;
   Dom(j:(j+norient-1),:)   = DomTmp;

   j = j + norient;
   Tmax = Tmin;
   Tmin = Tmin/2;
end

clear B;
clear tt;

output = output(rMin:rMax,cMin:cMax,:) / imS;