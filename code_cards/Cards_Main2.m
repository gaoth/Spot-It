
function Cards_Main2(imidx1,imidx2)
%% Load Images
        str1 = ['00' num2str(imidx1) '.png'];
        str2 = ['00' num2str(imidx2) '.png'];
        im1 = double(imread(str1))/255;
        im2 = double(imread(str2))/255;
        I1 = im1;
        I2 = im2;
%% Find feature points in DoG scale space
        [L1,s1] = j_DoGScaleSpace(rgb2gray(im1),9);
        [L2,s2] = j_DoGScaleSpace(rgb2gray(im2),9);
        Es1 = j_findSSExtrema(L1);
        Es2 = j_findSSExtrema(L2);
        Extr1 = j_filterBlobs(rgb2gray(im1),L1,Es1,s1);
        Extr2 = j_filterBlobs(rgb2gray(im2),L2,Es2,s2);
        err = zeros(size(Extr1,1),size(Extr2,1));
%% Build descriptor(similar to intenstiy.m in folder "images")
for keypoint1 = 1:size(Extr1,1)
    x1 = Extr1(keypoint1,1);
    y1 = Extr1(keypoint1,2);
    lev1 = Extr1(keypoint1,3);
    sigma1 = s1(lev1);
    Whalf1 = ceil(4*1.5*sigma1);
    if x1 - Whalf1 <= 0 || x1 + Whalf1 >= size(im1,2)
        continue
    end
    if y1 - Whalf1 <= 0 || y1 + Whalf1 >= size(im1,1)
        continue
    end
    
    patch1 = rotateim(im1,x1,y1,sigma1);
             
        
    for keypoint2 =  1:size(Extr2,1)
        x2 = Extr2(keypoint2,1);
        y2 = Extr2(keypoint2,2);
        lev2 = Extr2(keypoint2,3);
        sigma2 = s2(lev2);
    Whalf2 = ceil(3*1.5*sigma2);
    if x2 - Whalf2 <= 0 || x2 + Whalf2 >= size(im2,2)
        continue
    end
    if y2 - Whalf2 <= 0 || y2 + Whalf2 >= size(im2,1)
        continue
    end

    patch2 = rotateim(im2,x2,y2,sigma2);
    for chan = 1:3
            patch1chan = patch1(:,:,chan);
            patch2chan = patch2(:,:,chan);
            [r c] = size(patch1(:,:,1));
            patch2chan = imresize(patch2chan,[r,c],'bilinear');
        pat1vec = sort(patch1chan(:),'descend');
        pat2vec = sort(patch2chan(:),'descend');
        err(keypoint1,keypoint2) = err(keypoint1,keypoint2)+sum((pat1vec - pat2vec).^2) ;
     end
    
    end
end

for i = 1:size(err,1)
    for j = 1:size(err,2)
        if err(i,j) ==0
            err(i,j) = 200;
        end
        
    end
end
%% Matching corresponding points by error of descriptors
[f_err,xy1,xy2] = match1(err,Extr1,Extr2,10);
% [r,c,b] = size(im1);
%     figure;
%     im = [im1,im2];
%     imagesc(im);
%     hold on;
% for i=1:size(xy1,1)
%     
%     plot(xy1(i,1),xy1(i,2),'r+');
%     plot(xy2(i,1)+c,xy2(i,2),'r+');
%     line([xy1(i,1);xy2(i,1)+c],[xy1(i,2); xy2(i,2)],'color',rand(1,3),'linewidth',2);
% end
%% Remove bad matchings by distance 
[p1] = match_distance(f_err,xy1,xy2,['00' num2str(imidx1)],['00' num2str(imidx2)] ,im1);