function [tex,Y] = colorGabor(A)
[r,c,chan] = size(A);
if chan ~= 3
    error('Wrong image type');
end
Y =  100*(0.299*A(:,:,1)	+ 0.587 * A(:,:,2)	 + 0.114*A(:,:,3))/255;
tex = mGabor(Y,1,1,4);