function [patch,rottheta] = rottheta(im,x,y,sigma)

psize = ceil(3*1.5*sigma);
patch = im(y - psize:y + psize,x-psize:x+psize,1:3);
gm = rgb2gray(patch);
dy = conv2(gm,fspecial('sobel'),'same');
dx = conv2(gm,fspecial('sobel')','same');
mag = sqrt(dx.^2+dy.^2);
mag = conv2(mag,fspecial('gaussian',[size(patch,1),size(patch,2)],1.5*sigma),'same'); %%Gaussian weighting
ang = atan2d(dy, dx);



angd = 18-floor(ang/10); % map 180~-180 to 36 bins
cnts = zeros(36,1);
for i=1:36
    cnts(i) = sum(mag(angd==i));
end
[~,idx] = max(cnts);
rottheta = (18-idx)*10+5;