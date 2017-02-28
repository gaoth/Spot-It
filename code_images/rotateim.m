function imr = rotateim(im,x,y,sigma)
% input: im is image/patch, x,y are coordinates of keypoint, sigma is the
% scale parameter of the keypoint.
% output:imr is the image rotated to the domain orientation of the
% gradients
psize = ceil(3*1.5*sigma); %half patch size, derived from Lowe's paper and sampling principle of 3*sigma
patch = im(y - psize:y + psize,x-psize:x+psize,1:3);
gm = rgb2gray(patch);
dy = conv2(gm,fspecial('sobel'),'same');
dx = conv2(gm,fspecial('sobel')','same');
mag = sqrt(dx.^2+dy.^2);
mag = conv2(mag,fspecial('gaussian',[size(patch,1),size(patch,2)],1.5*sigma),'same'); %%Gaussian weighting of the magnitude
ang = atan2d(dy, dx); %compute degree of gradient orientation



angd = 18-floor(ang/10); % map degree in a range of -180~180 to 36 bins, each bin has a length of 10 degrees
cnts = zeros(36,1);
for i=1:36
    cnts(i) = sum(mag(angd==i));
end
[~,idx] = max(cnts); % find the peak of the histogram of orientation
theta = (18-idx)*10+5; % find the dominant orientation
imr = imrotate(patch, theta, 'crop', 'bilinear'); %rotate the patch according to the dominant orientation