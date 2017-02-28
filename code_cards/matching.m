function sim=matching(his1,his2,N1,N2)
%% matching with histvec
for l1=1:N1
    histvec1=his1(:,l1);
    for l2=1:N2
        stat1 = []; stat2 = [];
        histvec2=his2(:,l2);
        for k = 1:8
            stat1(k) = sum(histvec1(k:8:end));
            stat2(k) = sum(histvec2(k:8:end));
        end
        dom1 = find(stat1 == max(stat1));
        dom2 = find(stat2 == max(stat2));
        rot = dom2 - dom1;
        for k = 0:(size(histvec1,1)/8-1)
            histvec2(8*k+1:8*(k+1)) = circshift(histvec2(8*k+1:8*(k+1)),-rot);
        end
        sim(l1,l2) = dot(histvec1,histvec2)/(norm(histvec1)*norm(histvec2));
    end
end