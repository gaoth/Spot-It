function colorTotal=color(N,im,Label,S,C)
%% colorTotal saves the color information of superpixels with same label (within the same pattern)

r=size(im,1);
c=size(im,2);
colorTotal=zeros(30,N);

for fidx=1:N
A=zeros(r,c);
colorT=zeros(30,1);
same=find(Label(:,1)==fidx);
    for j=1:length(same)
        A=A+(S==(Label(same(j),2)));
        colorT=colorT+length(S==Label(same(j),2))*C(Label(same(j),2)).fv;
    end
    colorTotal(:,fidx)=colorT/sum(colorT);
end
end
