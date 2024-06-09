function [output,rMin,rMax,cMin,cMax] = mirrorImage(input,newSize)

[r,c,imS] = size(input);
output = zeros(newSize,newSize);

if r==newSize & c==newSize
    output = input;
    rMin = 1;rMax = r;
    cMin = 1;cMax = c;
    return;
end

rMin = floor((newSize-r)/2)+1;
rMax = rMin + r - 1;
cMin = floor((newSize-c)/2)+1;
cMax = cMin + c - 1;

% Area 0
output(rMin:rMax,cMin:cMax,:) = input;

% Area I
r1 = 1;             R1 = 1;
r2 = rMin -1;       R2 = rMin - 1;
c1 = 1;             C1 = 1;
c2 = cMin-1;        C2 = cMin - 1;
output(R1:R2,C1:C2) = flipud(fliplr(input(r1:r2,c1:c2)));
% Area II
r1 = 1;             R1 = rMin;
r2 = r;             R2 = rMax;
c1 = 1;             C1 = 1;
c2 = cMin-1;        C2 = cMin - 1;
output(R1:R2,C1:C2) = fliplr((input(r1:r2,c1:c2)));
% Area III
r1 = r - newSize + rMax + 1;            R1 = rMax+1;
r2 = r;                                 R2 = newSize;
c1 = 1;                                 C1 = 1;
c2 = cMin-1;                            C2 = cMin - 1;
output(R1:R2,C1:C2) = flipud(fliplr(input(r1:r2,c1:c2)));
% Area IV
r1 = r - newSize + rMax + 1;            R1 = rMax+1;
r2 = r;                                 R2 = newSize;
c1 = 1;                                 C1 = cMin;
c2 = c;                                 C2 = cMax;
output(R1:R2,C1:C2) = flipud(input(r1:r2,c1:c2));
% Area V
r1 = r - newSize + rMax + 1;            R1 = rMax+1;
r2 = r;                                 R2 = newSize;
c1 = c - newSize + cMax + 1;            C1 = cMax + 1;
c2 = c;                                 C2 = newSize;
output(R1:R2,C1:C2) = flipud(fliplr(input(r1:r2,c1:c2)));
% Area VI
r1 = 1;                                 R1 = rMin;
r2 = r;                                 R2 = rMax;
c1 = c - newSize + cMax + 1;            C1 = cMax + 1;
c2 = c;                                 C2 = newSize;
output(R1:R2,C1:C2) = fliplr((input(r1:r2,c1:c2)));
% Area VII
r1 = 1;                                 R1 = 1;
r2 = rMin-1;                            R2 = rMin-1;
c1 = c - newSize + cMax + 1;            C1 = cMax + 1;
c2 = c;                                 C2 = newSize;
output(R1:R2,C1:C2) = flipud(fliplr(input(r1:r2,c1:c2)));
% Area VIII
r1 = 1;                                 R1 = 1;
r2 = rMin-1;                            R2 = rMin-1;
c1 = 1;                                 C1 = cMin;
c2 = c;                                 C2 = cMax;
output(R1:R2,C1:C2) = flipud((input(r1:r2,c1:c2)));
