function [p1] = match_distance(f_err,loc1,loc2,str1,str2,image1) 
% error matrix is size m*n where m is the number of key points in image 1
% and n is the number of key points in image 2.
% loc1 is a m*2 matrix where each row is the location of a key point in
% image1. loc2 is an n*2 matrix where each row is the location of a
% key point in image2.
% it returns p1, which is the row of the lowest err in new_err matrix.

m = length(f_err);
tol = 0.5;   
dist = zeros(m,m);
for i = 1:m
    for j = 1:m
        dist(i,j) = norm(loc1(i,:)-loc1(j,:));     % compute distance between keypoint i and keypoint j in image1
    end
end
mean_dist = mean(dist,2);
max_dist = max(mean_dist);
[B,I] = sort(mean_dist);
fidx_dist = I(ceil(m*tol),end); % indexes of the longest distances 
new_err = f_err;    
new_err(fidx_dist) = inf;     % if distance too long, set err to inf
p1 = find(new_err == min(new_err));    % find minimum err under the limit of distance
% generate black and white picture
im_result = zeros(size(image1,1),size(image1,2));
im_result(loc1(p1,2),loc1(p1,1)) = 1;
figure, imshow(im_result)
imwrite(im_result,[num2str(str1),'_',num2str(str2),'.png']);
end