function [L,sa] = DoGScaleSpace(im,levels)

%
%  Regarding different parameters, the paper gives some empirical data which 
%  can be summarized as, number of octaves = 4, number of scale levels = 5, 
%  initial ?=1.6, k=2?? etc as optimal values.
%
%
%  Contrary to the Lowe DoG Scale Space, this does not separate the scales
%  into octaves, for simplicity.
%
%  im is a grayscale double image
%  levels are the number of levels you want in the scale-space
% 
%  L is the r x c x levels response DoG scale space
%  sa is the sigma's corresponding to each layer in the scale space.

k  = 1.1;
s1 = 0.9*k;   % 1.6 is too small

sa = cumprod( [s1 ones(1,levels)*k] );

L = zeros([size(im) levels]);

im_ = conv2(im,fspecial('gaussian',ceil(5*sa(1)),sa(1)),'same');

for i = 1:levels
    
    im__ = conv2(im,fspecial('gaussian',ceil(5*sa(i+1)),sa(i+1)),'same');
    
    L(:,:,i) = (im__ - im_);
    
    im_ = im__;

end

end