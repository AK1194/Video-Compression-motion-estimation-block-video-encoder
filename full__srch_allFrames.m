clc
clear all
close all
tstart=cputime;

f_ref(1:300,1:300)=0;
Im=imread('E:\foreman_10frames\f001.pgm');
f_ref(9:288,9:288)= Im(9:288,9:288);
srcFiles = dir('E:\foreman_10frames\*.pgm');

f_p=zeros(300,3000);
X=zeros(35,350);
Y=zeros(35,350);
SAD=zeros(1,9);
for frameNo=1:9
    filename = strcat('E:\foreman_10frames\',srcFiles(frameNo+1).name);
    f_2(1:300,1:300)=0;
    Im2= imread(filename);
    f_2(9:288,9:288)= Im2(9:288,9:288);
    
    s=1;
    X_motion=zeros(35);
    Y_motion=zeros(35);
    f_pre(1:300,1:300)=0;
    for i=9:8:288
        t=1;
        for j=9:8:288
            
            img_abs=zeros(8,8);
            img_16=f_ref(i-4:i+7+4,j-4:j+7+4);
            img_8=f_2(i:i+7,j:j+7);
            
            for p=1:8
                for q=1:8
                    
                    img_abs(p,q)=sum(sum((img_16(p:p+7,q:q+7)- img_8).^2));
                end
            end
            
            [M,I] = min(img_abs(:));
            [row_cor, col_cor] = ind2sub(size(img_abs),I);
            
            
            f_pre(i:i+7,j:j+7)=img_16(row_cor:row_cor+7,col_cor:col_cor+7);
            
            X_motion(s,t)= row_cor -5;
            Y_motion(s,t)= col_cor -5;
            t=t+1;
        end
        
        s=s+1;
    end
    f_p(1:300, 1+(300*frameNo):300*(frameNo+1))=f_pre;
    X(1:35, 1+(35*(frameNo-1)):35*frameNo)=X_motion;
    Y(1:35, 1+(35*(frameNo-1)):35*frameNo)=Y_motion;
    
    residu1=abs(f_2-f_pre);
    SAD(frameNo)=(sum(sum((residu1).^2)))/90000;
    figure,imshow(uint8(residu1));
    title('reduced residue after Full Search Operation');
    figure,imshowpair(f_2,f_ref,'diff');
    title('actual residue or difference between frames');
    f_ref=f_2;
end
telapsed=cputime-tstart;
Frame=[1 2 3 4 5 6 7 8 9];
figure,fullSearch=plot(Frame,SAD);
title('Sum of Absolute Difference [SAD] Vs Frames Plot');
ylabel('SAD found in Full Search');
xlabel('Frame number');
display('time elapsed in search');
display(telapsed);