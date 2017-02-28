function [sim,err]=compareColor(colorTotal1,colorTotal2)
    for i=1:size(colorTotal1,2)
        for j=1:size(colorTotal2,2)
            sim(i,j)=histintersect(colorTotal1(:,i),colorTotal2(:,j));
            err(i,j)=sum((colorTotal1(:,i)-colorTotal2(:,j)).^2);

        end
    end
    
end
function c = histintersect(a,b)
    c = sum(min(a,b));
end