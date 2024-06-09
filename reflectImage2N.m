% =========================================================================
% =========================================================================
% =========================================================================
%%%
%%% Create an image that has dimension that are 2^N
%%%
function [output,rLog,cLog,rMin,rMax,cMin,cMax] = reflectImage2N(input,extra)
% Get the image size
[r,c,imS] = size(input);

% Estimate the new size
rLog = 2^ceil(log2(r+r/2));
cLog = 2^ceil(log2(c+c/2));

% Create the empty ouput
output = zeros(rLog,cLog,imS);

% If no size change is needed return the images as is
if r==rLog & c==cLog
    output = input;
    rMin = 1;rMax = r;
    cMin = 1;cMax = c;
    return;
end

% Perform the mirroring
rMin = floor((rLog-r)/2)+1;
rMax = rMin + r - 1;
cMin = floor((cLog-c)/2)+1;
cMax = cMin + c - 1;

% Area 0
output(rMin:rMax,cMin:cMax,:) = input;
for i=1:imS
    % Area I
    r1 = 1;             R1 = 1;
    r2 = rMin -1;       R2 = rMin - 1;
    c1 = 1;             C1 = 1;
    c2 = cMin-1;        C2 = cMin - 1;
    output(R1:R2,C1:C2,i) = flipud(fliplr(input(r1:r2,c1:c2,i)));
    % Area II
    r1 = 1;             R1 = rMin;
    r2 = r;             R2 = rMax;
    c1 = 1;             C1 = 1;
    c2 = cMin-1;        C2 = cMin - 1;
    output(R1:R2,C1:C2,i) = fliplr((input(r1:r2,c1:c2,i)));
    % Area III
    r1 = r - rLog + rMax + 1;               R1 = rMax+1;
    r2 = r;                                 R2 = rLog;
    c1 = 1;                                 C1 = 1;
    c2 = cMin-1;                            C2 = cMin - 1;
    output(R1:R2,C1:C2,i) = flipud(fliplr(input(r1:r2,c1:c2,i)));
    % Area IV
    r1 = r - rLog + rMax + 1;              R1 = rMax+1;
    r2 = r;                                 R2 = rLog;
    c1 = 1;                                 C1 = cMin;
    c2 = c;                                 C2 = cMax;
    output(R1:R2,C1:C2,i) = flipud(input(r1:r2,c1:c2,i));
    % Area V
    r1 = r - rLog + rMax + 1;               R1 = rMax+1;
    r2 = r;                                 R2 = rLog;
    c1 = c - cLog + cMax + 1;               C1 = cMax + 1;
    c2 = c;                                 C2 = cLog;
    output(R1:R2,C1:C2,i) = flipud(fliplr(input(r1:r2,c1:c2,i)));
    % Area VI
    r1 = 1;                                 R1 = rMin;
    r2 = r;                                 R2 = rMax;
    c1 = c - cLog + cMax + 1;               C1 = cMax + 1;
    c2 = c;                                 C2 = cLog;
    output(R1:R2,C1:C2,i) = fliplr((input(r1:r2,c1:c2,i)));
    % Area VII
    r1 = 1;                                 R1 = 1;
    r2 = rMin-1;                            R2 = rMin-1;
    c1 = c - cLog + cMax + 1;                C1 = cMax + 1;
    c2 = c;                                 C2 = cLog;
    output(R1:R2,C1:C2,i) = flipud(fliplr(input(r1:r2,c1:c2,i)));
    % Area VIII
    r1 = 1;                                 R1 = 1;
    r2 = rMin-1;                            R2 = rMin-1;
    c1 = 1;                                 C1 = cMin;
    c2 = c;                                 C2 = cMax;
    output(R1:R2,C1:C2,i) = flipud((input(r1:r2,c1:c2,i)));
end