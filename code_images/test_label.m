subplot(1,2,1);imshow(im2);


r=size(im2,1);
c=size(im2,2);
%%%%%%%%%%%%%%%%%%
fidx=4;
A=zeros(r,c);
same=find(Label2(:,1)==fidx);
for i=1:length(same)
    A=A+(S2==(Label2(same(i),2)));
end
subplot(1,2,2);imagesc(A);