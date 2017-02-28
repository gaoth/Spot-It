function [Label,SS,SSo]=sameob(object,C,S)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find superpixels belonging to the same odject( mark them as same labels )

N=length(object);
%threshold=0.05;
c_thre=0.2;
d_thre=200;
label=(1:N)';
segments=C;

for i=1:N
    for j=1:N
        dist(i,j)= hypot(segments(object(i,1)).x-segments(object(j,1)).x, segments(object(i,1)).y-segments(object(j,1)).y);
        if  (dist(i,j)<100)
            cost(i,j)= sum(min(segments(object(i,1)).fv,segments(object(j,1)).fv));
        else
            cost(i,j)=0;
        end
%         if (cost(i,j)>threshold)
%             label(j,1)=label(i,1);
%         end
        if (cost(i,j)>c_thre)&&(dist(i,j)<d_thre)
            label(j,1)=label(i,1);
        end
    end
end

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
SS=zeros(size(S,1),size(S,1));
SSo=zeros(size(S,1),size(S,1));
r=15;
for t=1:length(label)
[r1,c1]=find(S==(Label(t,2)));
    for i=1:length(r1)
    SS(r1(i),c1(i))=Label(t,1);
    end
    
    
    for i=(min(r1)-r):(max(r1)+r)
          for j=(min(c1)-r):(max(c1)+r)
              SSo(i,j)= Label(t,1);
          end
    end
      
end






