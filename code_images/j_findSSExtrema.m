function [E] = j_findSSExtrema(L)

% Given the scale space layers image L (DoG Scale Space)
%  find local extrema and report them.
%
% E is an N by 3 matrix for N extrema, X, Y, Layer columns


[Y1,X1,Z1] = ind2sub(size(L),find(imregionalmax(L)));
[Y2,X2,Z2] = ind2sub(size(L),find(imregionalmax(-L)));
E= unique([X1,Y1,Z1; X2,Y2,Z2], 'rows');

