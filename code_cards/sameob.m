function [Label,SS]=sameob(object,C,S)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find superpixels belonging to the same odject( mark them as same labels )

N=length(object);
threshold=1.5;
label=(1:N)';
segments=C;

for i=1:N
    for j=1:N
        dist(i,j)= hypot(segments(object(i,1)).x-segments(object(j,1)).x, segments(object(i,1)).y-segments(object(j,1)).y);
        if  (dist(i,j)<58)
            cost(i,j)= sum(min(segments(object(i,1)).fv,segments(object(j,1)).fv));
        else
            cost(i,j)=0;
        end
        if (cost(i,j)>threshold)
            label(j,1)=label(i,1);
        end
        if (cost(i,j)>0.05)&&(dist(i,j)<35)
            label(j,1)=label(i,1);
        end
    end
end



%%%%%%%%%
% for i=1:N
% Q=i;
% reachable=zeros(N,1);
% while ~isempty(Q)
%     Q1=Q(1);
%     Q=Q(2:end);
%     paths=find(cost(Q1,1:N)>threhold);
%     for p=1:length(paths)
%         if (reachable(paths(p))~=1)
%             reachable(paths(p))=1;
%             Q=[Q paths(p)];
%         end
%     end
% end
% set=find(reachable);
% for j=1:length(set)
%     
%     label(set(j,1))=label(i);
% end
% 
% end



%%%%%%%normalize
label1=label;
M=length(unique(label));
hh=0;
for i=1:M
    temp=find(label1==max(label1));
    for j=1:length(temp)
        label1(temp(j))=0;
        label(temp(j),1)=M-hh;
    end
    hh=hh+1;
end
Label=[label,object];
SS=zeros(400,400);
for t=1:length(label)
[r1,c1]=find(S==(Label(t,2)));
    for i=1:length(r1)
    SS(r1(i),c1(i))=Label(t,1);
    end
end






