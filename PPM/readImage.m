function [A,err] = readImage(filename)

[A,err] = ppmRead(filename);
if err == 1
    error(sprintf('The file %s does not exsist', filename));
    return;
elseif err > 1
    A = double(imread(filename));
end