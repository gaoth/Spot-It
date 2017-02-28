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
    DoGtau = 0.1;
end

% number of extrema inputted
n = size(E,1);

[r,c,b] = size(im);

if (b ~= 1)
    fprintf('please supply a grayscale image, double, in range 0:1\n');
    E_ = [];
    return
end


%%%% YOU FILL IN THIS CODE
%%%% BE SURE TO FILTER OUT BOTH ON THE RESPONSE OF THE DOG AND THE
%%%% LOCAL IMAGE REGION BLOB-NESS




%%%% STOP HERE
