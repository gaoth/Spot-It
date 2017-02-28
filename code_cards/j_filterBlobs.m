function E_ = filterBlobs(im,L,E,sa,DoGtau)

% the original scale space blob detector returns all local extrema in scale
% space, which tends to return many pixels that do not seem to be blobs.
%
% This function filters out extrema that had too weak a response in the 
%  DoG as well as non-blob-like regions.
%
% im is the grayscale, double image in the 0:1 range
% L is the DoG scale space
% E is the Extrema N x 3 matrix  (each row is X,Y,level)
% sa is the sigma vector (roughly 3*sigma is a size in image)
% DoGtau (optional) is the filter on the extrema response

if nargin<5
    DoGtau = 0.05;
end

% number of extrema inputted
n = size(E,1);

[r,c,b] = size(im);

if (b ~= 1)
    fprintf('please supply a grayscale image, double, in range 0:1\n');
    E_ = [];
    return
end



take = zeros(n,1);


dy = conv2(im,fspecial('sobel'),'same');
dx = conv2(im,fspecial('sobel')','same');

for i = 1:n

    if (abs(L(E(i,2),E(i,1),E(i,3))) < DoGtau)
        % the actual response of the extrema is too low.  throw away
        continue
    end
    
    %take(i) = 1;
    
    yy = E(i,2);
    xx = E(i,1);
    w  = ceil(sa(E(i,3))*3/2);
    x1 = max(1,xx-w);
    y1 = max(1,yy-w);
    x2 = min(xx+w,c);
    y2 = min(yy+w,r);
    
    Px = dx(y1:y2,x1:x2);
    Py = dy(y1:y2,x1:x2);
     
    e = harris(Px,Py)/numel(Px);
    t = prod(e)/sum(e)/numel(Px);
     
    if (~isnan(t)) & (min(e) > 0.2)
        take(i) = 1;
    end
end

E_ = E(take==1,:);

end



function [e] = harris(Px,Py)

    dxdx = sum(sum(Px.*Px));
    dxdy = sum(sum(Px.*Py));
    dydy = sum(sum(Py.*Py));
    
    e = eigs([dxdx,dxdy;dxdy,dydy]);
end

