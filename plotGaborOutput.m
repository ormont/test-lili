function plotGaborOutput(inImage,gaborImage,wSize,T,color)
imS = size(gaborImage);
r   = imS(1);
c   = imS(2);

if length(imS) == 3
    imS = imS(3);
else
    imS = 1;
end

g   = gaborImage;
d   = gaborImage;
for i=1:imS
    d(:,:,i) = medfilt2(gaborImage(:,:,i),[wSize wSize]);
end

sumG = sum(g,3);
sumD = sum(d,3);

if T > 0
    sumG = max(sumG-T,0);
    sumD = max(sumD-T,0);
    
    for x=1:r
    for y=1:c
        if sumG(x,y) == 0
            g(x,y,:)=0;
            sumG(x,y) = 1;
        else
            sumG(x,y) = sumG(x,y)  +T;
        end
        if sumD(x,y) == 0
            d(x,y,:)=0;
            sumD(x,y) = 1;
        else
            sumD(x,y) = sumD(x,y)  +T;
        end
    end
    end    
end
figure;
% subplot(1,2,1);imshow(sumG);caxis auto;colormap(color);colorbar;title('sumG');
% subplot(1,2,2);imshow(sumD);caxis auto;colormap(color);colorbar;title('sumD');
subplot(1,2,1);imshow(sumG);caxis auto;colormap jet;colorbar;title('sumG');
subplot(1,2,2);imshow(sumD);caxis auto;colormap jet;colorbar;title('sumD');
pause;

figure;
for i=1:imS
    subplot(2,2,1);
    imshow((g(:,:,i)));
    caxis auto;
  %  caxis([0 50]);
    colormap jet;colorbar;title(i);
    subplot(2,2,2);
    imshow((d(:,:,i)));
    caxis auto;
 %   caxis([0 50]);
    colormap jet;colorbar;title(i);
    subplot(2,2,3);
    imshow(255*g(:,:,i)./max(sumG,1));
    caxis auto;
 %   caxis([0 50]);
    colormap jet;colorbar;title(i);
    subplot(2,2,4);
    imshow(255*d(:,:,i)./max(sumD,1));
    caxis auto;
 %   caxis([0 50]);
    colormap jet;
    colorbar;title(i);
    pause
end

