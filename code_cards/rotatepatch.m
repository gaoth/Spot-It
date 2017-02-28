function patch_r = rotatepatch(patch,whalf)

%% compute rotation degree
% whalf = 16;
% patch = double(imread('001.png'))/255;
gm = rgb2gray(patch);
%gm = rgb2gray(sm);
dy = conv2(gm,[-1 0 1]','same');
dx = conv2(gm,[-1 0 1],'same');
% dy = dy(2:end-1, 2:end-1);
% dx = dx(2:end-1, 2:end-1);

mag = sqrt(dx.^2+dy.^2);
mag = conv2(mag,fspecial('gaussian',[2*whalf+1,2*whalf+1],1.5*whalf/3),'same'); %%Gaussian weighting
ang = atan2(dy, dx);

angd = 18-floor(ang/10); % map 180~-180 to 36 bins

cnts = zeros(36,1);
for i=1:36
    cnts(i) = sum(mag(angd==i));
end
[~,idx] = max(cnts);

theta = (18-idx)*10+5;
% subplot(1,2,1); imagesc(patch)
%% sift
   
    % rotate
%     dy = imrotate(dy, -theta, 'crop', 'bilinear');
%     dx = imrotate(dx, -theta, 'crop', 'bilinear');
    patch_r = imrotate(patch,-theta,'crop','bilinear');

%     dy = dy(1+margin_long:end-1-margin_long, ...
%         1+margin_long:end-1-margin_long);
%     dx = dx(1+margin_long:end-1-margin_long, ...
%         1+margin_long:end-1-margin_long);
    


