inImage = readImage('E:\VISUAL_ATTENTION\GABOR\GABOR MATLAB 1\Images\Test1.ppm');

image(uint8(inImage))
caxis auto;

%[tex, Y] = colorGabor(inImage);
%image(Y)
%outputMethod = 1;
%nscale = 8;
%norient = 4;
%[output,Gabors,Dom] = GaborFinalB(inImage,outputMethod,nscale,norient);