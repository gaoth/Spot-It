function [f_err,xy1,xy2]  = match1(err,Extr1,Extr2,corrsnum)
% input:err is error matrix, Extr1, Extr2 are extrema matrix, coorsnum is 
% number of correspondance
% output:f_err is the error vector of which elements are the error of 
% correspondances. xy1 xy2 are the coordinates of the correspondace in
% image 1 and image 2, respectively.

errvec = err(:);
errvecs = sort(errvec);

errmin_c = [];
errmin_r = [];
f_err = errvecs(1:corrsnum);
num = 1;
while num  <= corrsnum
    [temp_r temp_c]= find(err == errvecs(num)); 
    errmin_r = [errmin_r; temp_r];
    errmin_c = [errmin_c;temp_c];
    num = num + length(temp_c);
    
end
xy1 = zeros(length(errmin_r),2);
xy2 = zeros(length(errmin_c),2);
for i = 1:length(errmin_r)
    xy1(i,1) = Extr1(errmin_r(i),1);
    xy1(i,2) = Extr1(errmin_r(i),2);
end
for j = 1:length(errmin_c)
    xy2(j,1) = Extr2(errmin_c(j),1);
    xy2(j,2) = Extr2(errmin_c(j),2);
end