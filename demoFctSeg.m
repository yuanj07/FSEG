% Test FSEG

clear
tic

ws=17; % window size for computing features
segn=0; % number of segment. Determine automatically if set to 0

I=imread('aerial.jpg');
figure(1), imshow(I,[]);
title('Input Image')
pause(.1)

f1=fspecial('log',[3,3],.5);
f2=fspecial('log',[5,5],.8);
f3=fspecial('log',[7,7],1.2);

Igr=rgb2gray(I);
Ig1=subImg(Igr,f1,f2,f3);
Ig=cat(3,single(I),Ig1);

res=FctSeg(Ig,ws,segn,1);

% output format
img=single(I);
sz=size(res);
resU=[res(2:end,:);res(end,:)];
resB=[res(1,:);res(1:end-1,:)];
resL=[res(:,2:end),res(:,end)];
resR=[res(:,1),res(:,1:end-1)];
bmap=abs(resU-res)+abs(resB-res)+abs(resL-res)+abs(resR-res);
res_shw=zeros(sz(1),sz(2),3);
for i=1:max(res(:))
    idx=find(res==i);
    res_shw(idx)=mean(img(idx));
    res_shw(idx+sz(1)*sz(2))=mean(img(idx+sz(1)*sz(2)));
    res_shw(idx+sz(1)*sz(2)*2)=mean(img(idx+sz(1)*sz(2)*2));
end
rband=img(:,:,1);
idx=find(bmap>0);
res_shw(idx)=max(rband(:));
res_shw(idx+sz(1)*sz(2))=0;
res_shw(idx+sz(1)*sz(2)*2)=0;

figure(2), imshow(uint8(res_shw));
title('Segmentation result')

toc


