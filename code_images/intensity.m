function err=intensity(Extr1,Extr2,s1,s2,im1,im2)
%input:local extrema matrix generated from DoGscalespace,Extr1,Extr2, 
%      scale parameter s1,s2, image,im1,im2
%output: error matrix, rows are indexes of keypoints in image1 and columns
%are indexes of keypoints in image2

err = zeros(size(Extr1,1),size(Extr2,1));
for keypoint1 = 1:size(Extr1,1)
    x1 = Extr1(keypoint1,1); %%x coordinate of keypoint1
    y1 = Extr1(keypoint1,2); %%y coordinate of keypoint1
    lev1 = Extr1(keypoint1,3);
    sigma1 = s1(lev1);
    Whalf1 = ceil(3*1.5*sigma1); %half patch size
    if x1 - Whalf1 <= 0 || x1 + Whalf1 >= size(im1,2)  %%discard the keypoint of which patch is outside the image
        continue
    end
    if y1 - Whalf1 <= 0 || y1 + Whalf1 >= size(im1,1)
        continue
    end
    

            patch1 = rotateim(im1,x1,y1,sigma1);  %%rotate the patch to the same orientaiton

        
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
            patch2chan = imresize(patch2chan,[r,c],'bilinear');   %% resize patch2 to the same size as patch1


        pat1vec = sort(patch1chan(:),'descend');  %%generate the descriptor based on the pixel value
        pat2vec = sort(patch2chan(:),'descend');
        err(keypoint1,keypoint2) = err(keypoint1,keypoint2)+sum((pat1vec - pat2vec).^2) ; %%compute the error matrix
     end
    
    end
end

for i = 1:size(err,1)
    for j = 1:size(err,2)
        if err(i,j) ==0
            err(i,j) = 200; %%set the error of discarded keypoint to a large number
        end
        
    end
end