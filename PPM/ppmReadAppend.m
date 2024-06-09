function [out,err] = ppmReadAppend(filename,channelsPerImage)

out = 0;
[tmp,err] = ppmRead(filename);

if err ~= 0
    return;
end

[rows,cols,chans] = size(tmp);

nImages = chans / channelsPerImage;

out  = reshape(tmp,[rows,cols,channelsPerImage,nImages]);