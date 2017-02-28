function Images_Main(imidx1,imidx2)

%% Load Image

        str1 = ['00' num2str(imidx1) '.png'];
        str2 = ['00' num2str(imidx2) '.png'];
        im1 = double(imread(str1))/255;
        im2 = double(imread(str2))/255;
        I1 = im1;
        I2 = im2;
        %% Do segmentation to Label objects for Im1
        [S1,C1] = slic(im1,300);
        C1 = reduceSeg(im1,C1,S1);
        keyindex = 1;
        [B1,num1] = graphcut(S1,C1,keyindex);
        B=B1;
        num=unique(num1);
        idx=1;
        for i=1:length(C1)
            if isempty(find(num==i, 1))
                object(idx,1)=i;
                idx=idx+1;
            end
        end
        %% Give superpixels within one object the same labels 

        [Label1,SS,SSo]=sameob(object,C1,S1);
        N1=length(unique(Label1(:,1)));      

        test=zeros(size(im1,1),size(im1,2));
        for t=1:length(num)
            test=test+(S1==num(t,1));
        end

        %% test for image removed background
        for i=1:size(im1,1)
            for j=1:size(im1,2)
                if test(i,j)~=0
                    im1(i,j,:)=235;
                end
            end
        end
         %figure()
         %imshow(im1);


        %% Do segmentation to remove background and Label objects for Im2
        [S2,C2] = slic(im2,300);
        cmap = rand(max(S2(:)),3);
        C2 = reduceSeg(im2,C2,S2);
        keyindex1 = 1;
        [B1,num1_] = graphcut(S2,C2,keyindex1);

        num_=num1_;

        idx=1;
        for i=1:length(C2)
            if isempty(find(num_==i, 1))
                object2(idx,1)=i;
                idx=idx+1;
            end
        end

        %% Label
        [Label2,SS2,SS2o]=sameob(object2,C2,S2);
         N2=length(unique(Label2(:,1)));   

        test2=zeros(size(im2,1),size(im2,2));
        for t=1:length(num_)
            test2=test2+(S2==num_(t,1));
        end


        for i=1:size(im2,1)
            for j=1:size(im2,2)
                if test2(i,j)~=0
                    im2(i,j,:)=235;
                end
            end
        end

        % figure()
        % imshow(im2);
        %% Compute Similarity of color between objects
        colorTotal1=color(N1,im1,Label1,S1,C1);
        colorTotal2=color(N2,im2,Label2,S2,C2);
        [sim,~]=compareColor(colorTotal1,colorTotal2);
        
        %% Find feature points in DoG Space
        [L1,sa1,E1] = DoGScaleSpace(rgb2gray(I1),9);
        E1_ = j_filterBlobs(rgb2gray(I1),L1,E1,sa1);
        [L2,sa2,E2] = DoGScaleSpace(rgb2gray(I2),9);
        E2_ = j_filterBlobs(rgb2gray(I2),L2,E2,sa2);

        %vizScaleSpace(L1,E1_,sa1);

      

         %% Use Intensity(pixel value) to describe points
         err=intensity(E1_,E2_,sa1,sa2,I1,I2);

         %% Matching
            
          kCorr=10;
          [f_err,xy10,xy20] = match1(err,E1_,E2_,kCorr);

         t=1;
        %% compare color similarity of matched objets to remove matches of mistakes
    
        %If color similarity between two linked objects is less than the
        %threshold of 0.65, the matching will be rejected
           for i=1:kCorr
               l1=SSo(xy10(i,2),xy10(i,1));
               l2=SS2o(xy20(i,2),xy20(i,1));
               if l1*l2~=0
                    if sim(l1,l2)> 0.65
                        xy1(t,:)=xy10(i,:);
                        xy2(t,:)=xy20(i,:);
                        temp(t,:)=[l1,l2];
                        t=t+1;
                    end
               end      
           end


        %% Display corresponding objects with white points
        % Find two matched objects with largest number of matchings between
        % them, the matrix Link saves the matching information between
        % objects.
        % If two pairs of objects have same number of links, compare their
        % color similarity.
         Link=zeros(N1,N2);
        for i=1:size(temp,1)
            Link(temp(i,1),temp(i,2))=Link(temp(i,1),temp(i,2))+1;
        end
        if length(find(Link==max(max(Link))))==1
            [white1,white2]=find(Link==max(max(Link)),1);
        elseif length(find(Link==max(max(Link))))>1
            [wtemp1,wtemp2]=find(Link==max(max(Link)));
            wmax=sim(wtemp1(1),wtemp2(1));
            for ii=2:length(wtemp1)
                if sim(wtemp1(ii),wtemp2(ii))>wmax
                    wmax=sim(wtemp1(ii),wtemp2(ii));
                    white1=wtemp1(ii);
                    white2=wtemp2(ii);
                end
            end
        end
        %test matchings
        SS(SS~=white1)=0;
        SS(SS==white1)=1;
        %  figure()
        %  imshow(SS);
        SS2(SS2~=white2)=0;
        SS2(SS2==white2)=1;


%          imresult=[SS,SS2];
%          figure()
%          imshow(imresult);
       %% Find a point in matched objects to display
        PP_1=find(Label1(:,1)==white1,1);
        ii=Label1(PP_1,2);
        p1=[C1(ii).y,C1(ii).x];
        PP_2=find(Label2(:,1)==white2,1);
        jj=Label2(PP_2,2);
        p2=[C2(jj).y,C2(jj).x];
        res1=zeros(size(I1,1),size(I1,2));
        res2=res1;
        res1(p1(1,1),p1(1,2))=1;
        res2(p2(1,1),p2(1,2))=1;

         imresult=[res1,res2];
%          figure()
%          imshow(imresult);
        imwrite(res1,['00' num2str(imidx1) '_00' num2str(imidx2) '.png']);
        %% Plot lines of matchings
%          figure;
%             im = [I1,I2];
%             imagesc(im);
%             hold on;
%         [r,c,b] = size(im1);
%         for i=1:size(xy1,1)
%             plot(xy1(i,1),xy1(i,2),'r+');
%             plot(xy2(i,1)+c,xy2(i,2),'r+');
%             line([xy1(i,1);xy2(i,1)+c],[xy1(i,2); xy2(i,2)],'color',rand(1,3),'linewidth',2);
%         end
    end
