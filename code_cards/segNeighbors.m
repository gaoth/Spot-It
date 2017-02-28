function Bmap = segNeighbors(svMap)

%%% function Bmap = segNeighbors(svMap)
%  EECS 504 Foundations of Computer Vision
%
%  Implement the code to compute the adjacency matrix for the superpixel graph
%  captured by svMap
%
%  INPUT:  svMap is an integer image with the value of each pixel being
%           the id of the superpixel with which it is associated
%  OUTPUT: Bmap is a binary adjacency matrix NxN (N being the number of superpixels
%           in svMap).  Bmap has a 1 in cell i,j if superpixel i and j are neighbors.
%           Otherwise, it has a 0.  Superpixels are neighbors if any of their
%           pixels are neighbors.

segmentList = unique(svMap);
segmentNum = length(segmentList);

Bmap=zeros(segmentNum,segmentNum);

%%%% IMPLEMENT the calculation of the adjacency
% for i=1:segmentNum
%     [curr,curc]=find(svMap==i);
%     for n1=1:length(curr)
%         
%     for j=1:segmentNum
%         [comr,comc]=find(svMap==j);
%         if i~=j
%             for n2=1:length(comr)
%             d=sqrt((curr(n1)-comr(n2))^2+(curc(n1)-comc(n2))^2);
%             if d<2
%                 Bmap(i,j)=1;
%             end
%             end
%         end
%     end
%     end
% end
[r,c]=size(svMap);
for i=2:r-1
    for j=2:c-1
        nei=[svMap(i-1,j-1);svMap(i-1,j);svMap(i-1,j+1);svMap(i,j-1);
            svMap(i,j+1);svMap(i+1,j-1);svMap(i+1,j);svMap(i+1,j+1)];
        for t=1:8
            if nei(t,:)~=svMap(i,j)
                Bmap(svMap(i,j),nei(t,:))=1;
            end
        end
    end
end
