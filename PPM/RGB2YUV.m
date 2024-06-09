function out = RGB2YUV(in,how)


[rows,cols,chans] = size(in);

if chans ~= 3
    error('Wrong type of image');
end

if how == 0
    out(:,:,1) =   0.299 *in(:,:,1) +  0.587*in(:,:,2) +  0.114*in(:,:,3);
    out(:,:,2) =  -0.147 *in(:,:,1) - 0.289	*in(:,:,2) +  0.436*in(:,:,3);
    out(:,:,3) =   0.615 *in(:,:,1) - 0.515	*in(:,:,2) - 0.100*in(:,:,3);
else
    out(:,:,1) =   in(:,:,1) +  1.1398*in(:,:,3);
    out(:,:,2) =   in(:,:,1) -0.3946	*in(:,:,2) -0.5805*in(:,:,3);
    out(:,:,3) =   in(:,:,1) + 2.0320	*in(:,:,2) -0.0005*in(:,:,3);
end
	