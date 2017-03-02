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
SAD(frameNo)=(sum(sum((residu).^2)))/90000;
figure,imshow(uint8(residu));
title('reduced residue after Logarithmic Search Operation');
figure,imshowpair(f_2,f_ref,'diff');
title('actual residue or difference between frames');

f_ref=f_2;
end
telapsed=cputime-tstart;
Frame=[1 2 3 4 5 6 7 8 9];
figure,LogSearch=plot(Frame,SAD);
title('Sum of Absolute Difference [SAD] Vs Frames Plot');
ylabel('SAD found in Logarithmic Search');
xlabel('Frame number');
display('time elapsed in search');
display(telapsed);
