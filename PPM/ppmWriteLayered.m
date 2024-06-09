function ppmWriteLayered(filename,method,inputImage)

[rows,cols,channels,sc] = size(inputImage);

ppmWrite(filename,method,inputImage(:,:,:,1));

for i=2:sc
    ppmWriteAppend(filename,method,inputImage(:,:,:,i))
end
