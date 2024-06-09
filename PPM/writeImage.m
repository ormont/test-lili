function writeImage(filename,image,args)

% Verify the needed inputs
if isfield(args,'printMethod') == 0
    args.printMethod     = 'tif';
end

if isfield(args,'printPrec') == 0
    args.printPrec = 'P6';
end

% Verify if the image can be printed using the current method
[rows,cols,channels] = size(image);

if strcmp(args.printMethod,'ppm')
    ppmWrite(filename,args.printPrec,image);
else
    imwrite(uint8(image),name,args.printMethod);
end