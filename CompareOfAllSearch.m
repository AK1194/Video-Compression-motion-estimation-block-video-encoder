%% Full Search
clc
clear all
close all
Frame=[1 2 3 4 5 6 7 8 9];
f_ref(1:300,1:300)=0;
Im=imread('E:\foreman_10frames\f001.pgm');
f_ref(9:288,9:288)= Im(9:288,9:288);
srcFiles = dir('E:\foreman_10frames\*.pgm');

f_p=zeros(300,3000);
X=zeros(35,350);
Y=zeros(35,350);
SAD_Full=zeros(1,9);
tstart_full=cputime;
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
    SAD_Full(frameNo)=(sum(sum((residu1).^2)))/90000;
    figure,imshow(uint8(residu1));
    title('reduced residue after Full Search Operation');
    figure,imshowpair(f_2,f_ref,'diff');
    title('actual residue or difference between frames');
    f_ref=f_2;
end
telapsed_full=cputime-tstart_full;
figure,fullSearch=plot(Frame,SAD_Full);
title('Sum of Absolute Difference [SAD] Vs Frames Plot');
ylabel('SAD found in Full Search');
xlabel('Frame number');

%% Logarithmic Search



f_ref(1:300,1:300)=0;
Im=imread('E:\foreman_10frames\f001.pgm');
 f_ref(9:288,9:288)= Im(9:288,9:288);
f_p=zeros(300,3000);
X=zeros(35,350);
Y=zeros(35,350);
SAD_Log=zeros(1,9);
tstart_log=cputime;
for frameNo=1:9
    filename = strcat('E:\foreman_10frames\',srcFiles(frameNo+1).name);
     f_2(1:300,1:300)=0;
    Im2= imread(filename);
    f_2(9:288,9:288)= Im2(9:288,9:288); 
    f_pre(1:300,1:300)=0;

s=1;
X_motion= zeros(22,22);
Y_motion=zeros(22,22);
for i=9:8:288
    t=1;
    for j=9:8:288
 img_abs=[0 0 0 0 0];
img_16=f_ref(i-4:i+7+4,j-4:j+7+4);
img_8=f_2(i:i+7,j:j+7);
flag = 1;
I=1;
Rc=5;
Cc=5;
step_size=4;

while flag
    r=[Rc,Rc-step_size,Rc,Rc,Rc+step_size];
    c=[Cc,Cc,Cc-step_size,Cc+step_size,Cc];
   
    for g=1:5
    if r(g)<=0 || r(g)>=10
        img_abs(g)=255*64*255;
    elseif c(g)<=0 || c(g)>=10
        img_abs(g)=255*64*255;
    elseif g==I && g-1>0
        img_abs(g)=255*64*255;
    else 
        img_abs(g)=sum(sum((img_16(r(g):r(g)+7,c(g):c(g)+7)- img_8).^2));
    end
    end
  

[M,I] = min(img_abs);
switch (I)
    case 1
        step_size=step_size/2;
    case 2
        Rc=Rc-step_size;
    case 3
        Cc=Cc-step_size;
    case 4
        Cc=Cc+step_size;
    case 5
        Rc=Rc+step_size;    
end
if step_size<1
    flag=0;  
    break;
else
    continue;
end
end
    f_pre(i:i+7,j:j+7)=img_16(Rc:Rc+7,Cc:Cc+7);
    X_motion(s,t)= Rc-5;
    Y_motion(s,t)= Cc-5;

t=t+1;
    end
    s=s+1;

end
f_p(1:300, 1+(300*frameNo):300*(frameNo+1))=f_pre;
X(1:35, 1+(35*(frameNo-1)):35*frameNo)=X_motion;
Y(1:35, 1+(35*(frameNo-1)):35*frameNo)=Y_motion;


residu=abs(f_2-f_pre);
SAD_Log(frameNo)=(sum(sum((residu).^2)))/90000;
figure,imshow(uint8(residu));
title('reduced residue after Logarithmic Search Operation');
figure,imshowpair(f_2,f_ref,'diff');
title('actual residue or difference between frames');

f_ref=f_2;
end
telapsed_log=cputime-tstart_log;
figure,LogSearch=plot(Frame,SAD_Log);
title('Sum of Absolute Difference [SAD] Vs Frames Plot');
ylabel('SAD found in Logarithmic Search');
xlabel('Frame number');

%% Full and Logarithmic Search


f_ref(1:300,1:300)=0;
Im=imread('E:\foreman_10frames\f001.pgm');
f_ref(9:288,9:288)= Im(9:288,9:288);

f_p=zeros(300,3000);
X=zeros(35,350);
Y=zeros(35,350);
fg=1;
change=0;
SAD_fullLog=zeros(1,9);
tstart_fullLog=cputime;
for frameNo=1:9
    filename = strcat('E:\foreman_10frames\',srcFiles(frameNo+1).name);
    f_2(1:300,1:300)=0;
    Im2= imread(filename);
    f_2(9:288,9:288)= Im2(9:288,9:288);
    
    X_motion=zeros(35);
    Y_motion=zeros(35);
    
    f_pre(1:300,1:300)=0;
    
    if fg==1
        
        s=1;
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
        
    elseif fg==0
        s=1;
        X_motion= zeros(22,22);
        Y_motion=zeros(22,22);
        for i=9:8:288
            t=1;
            for j=9:8:288
                img_abs=[0 0 0 0 0];
                img_16=f_ref(i-4:i+7+4,j-4:j+7+4);
                img_8=f_2(i:i+7,j:j+7);
                flag = 1;
                I=1;
                Rc=5;
                Cc=5;
                step_size=4;
                
                while flag
                    r=[Rc,Rc-step_size,Rc,Rc,Rc+step_size];
                    c=[Cc,Cc,Cc-step_size,Cc+step_size,Cc];
                    
                    for g=1:5
                        if r(g)<=0 || r(g)>=10
                            img_abs(g)=255*64*255;
                        elseif c(g)<=0 || c(g)>=10
                            img_abs(g)=255*64*255;
                        elseif g==I && g-1>0
                            img_abs(g)=255*64*255;
                        else
                            img_abs(g)=sum(sum((img_16(r(g):r(g)+7,c(g):c(g)+7)- img_8).^2));
                        end
                    end
                    
                    
                    [M,I] = min(img_abs);
                    switch (I)
                        case 1
                            step_size=step_size/2;
                        case 2
                            Rc=Rc-step_size;
                        case 3
                            Cc=Cc-step_size;
                        case 4
                            Cc=Cc+step_size;
                        case 5
                            Rc=Rc+step_size;
                    end
                    if step_size<1
                        flag=0;
                        break;
                    else
                        continue;
                    end
                end
                f_pre(i:i+7,j:j+7)=img_16(Rc:Rc+7,Cc:Cc+7);
                X_motion(s,t)= Rc-5;
                Y_motion(s,t)= Cc-5;
                
                t=t+1;
            end
            s=s+1;
        end
        
    end
   
    
    change=change+1;
    if change<3
        fg=0;
    elseif change==3
        change=0;
        fg=1;
    end
    
    f_p(1:300, 1+(300*frameNo):300*(frameNo+1))=f_pre;
    X(1:35, 1+(35*(frameNo-1)):35*frameNo)=X_motion;
    Y(1:35, 1+(35*(frameNo-1)):35*frameNo)=Y_motion;
    
    residu1=abs(f_2-f_pre);
    SAD_fullLog(frameNo)=(sum(sum((residu1).^2)))/90000;
    figure,imshow(uint8(residu1));
    title('reduced residue after the Search Operation');
    figure,imshowpair(f_2,f_ref,'diff');
    title('actual residue or difference between frames');
    f_ref=f_2;
end
telapsed_fullLog=cputime-tstart_fullLog;
figure,FullLogSearch=plot(Frame,SAD_fullLog);
title('Sum of Absolute Difference [SAD] Vs Frames Plot');
ylabel('SAD found in Hybrid of Full Search and Logarithmic Search');
xlabel('Frame number');


%% Comparision Among these Search Algorithm

figure,plot(Frame,SAD_Full,'r-.o',Frame,SAD_fullLog,'k-*',Frame,SAD_Log,'g--s');
title('Sum of Absolute Difference [SAD] Vs Frames Plot');
ylabel('SAD found using Different Search Algorithms');
xlabel('Frame number');

timeelapsed=[19.2969,10.7813, 13.3281];
% Search=['full_Search','Log_Search', 'FullLog_Search'];
figure,bar(timeelapsed);
xlabel('fullSearch               LogSearch               FullLogSearch');
ylabel('time elapsed');
