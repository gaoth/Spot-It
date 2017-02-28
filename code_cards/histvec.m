function v = histvec(image,mask,b)

% function v = histvec(image,mask,b)
%
%     EECS 504 Foundation of Computer Vision;
%     Jason Corso
%
%  For each channel in the image, compute a b-bin histogram (uniformly space
%  bins in the range 0:1) of the pixels in image where the mask is true. 
%  Then, concatenate the vectors together into one column vector (first
%  channel at top).
%
%  mask is a matrix of booleans the same size as image.
% 
%  normalize the histogram of each channel so that it sums to 1.
%
%  You CAN use the hist function.
%  You MAY loop over the channels.
[m,n,chan]=size(image);


c = 1/b;       % bin offset
x = c/2:c:1;   % bin centers
idx=0;

for i=1:m
    for j=1:n
        if mask(i,j)==1
            idx=idx+1;
        imr(idx,1)=image(i,j,1);
        img(idx,1)=image(i,j,2);
        imb(idx,1)=image(i,j,3);
        end
    end
end

hr=imhist((imr-x(1,1))*1.1111,b);
hr=hr/sum(hr);
hg=imhist((img-x(1,1))*1.1111,b);
hg=hg/sum(hg);
hb=imhist((imb-x(1,1))*1.1111,b);
hb=hb/sum(hb);
%%%%% IMPLEMENT below this line into a 3*b by 1 vector  v
v=[hr;hg;hb];
%%  3*b because we have a color image and you have a separate 
%%  histogram per color channel

