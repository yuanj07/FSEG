function [SegLab]=FctSeg(Ig,ws,segn,NC)
% Compute segment labels for natural images

% Input:
%     Ig: an N1*N2*bn array containing bn filter responses
%     ws: Integration scale (a ws*ws square window)
%     segn: segment number. 0 for automatically selection
%     NC: 1 for imposing nonnegativity constraint. 0 for no constraint.
% Output: label map of the segmented image
%
%     default parameters:
%     omega=.05; For segment number estimation based on singular values
%                  need to be tuned if the choice of filters are changed.

Ig=single(Ig);
[N1,N2,bn]=size(Ig);

omega=.05;

ws=floor(ws/2);
sh_mx=SHcomp(bn,ws,Ig);

bb=size(sh_mx,1);
    
Y=reshape(sh_mx,bb,N1*N2);

S=double(Y*Y');
[v,d]=eig(S);
d=single(d);
v=single(v);
[dst,Idx]=sort(diag(d),'descend');
k=sqrt(abs(dst));
if segn==0 % estimate the segment number    
    tmp=0;
    lse=zeros(length(k),1);
    for i=length(k):-1:1;
        tmp=tmp+k(i).^2;
        lse(i)= tmp/sum(k.^2);
    end
    a=find(lse>omega);
    segn=length(a);

    if segn<=1
        segn=2;
        disp('Warning: Segment number is set to 2. Adjust omega for better results.')
    end
end

dimn=segn;

U1=v(:,Idx(1:dimn));

Y1=(Y'*U1)'; % project features onto the subspace

% Compute edgeness
tmp=SHedge_1s(ws,1,sh_mx);
intreg=zeros(N1,N2,'uint8');
intreg1=zeros(N1,N2,'uint8');
intreg1(tmp<.4*max(tmp(:)))=1;
intreg(ws+1:end-ws,ws+1:end-ws)=intreg1(ws+1:end-ws,ws+1:end-ws);

idx=find(intreg==1);
len=length(idx);
Mx=Y1(:,idx);

% Representative feature estimation

tmplt=zeros(dimn,segn,'single');
L=sum(Mx.^2);
[~, rn]=max(L);
tmplt(:,1)=Mx(:,rn);
n=1;

seedmap=zeros(N1,N2);
seedmap(idx(rn))=1;

tn=n+1;
CY=repmat(tmplt(:,n),1,len);
ccos=sqrt(sum((Mx-CY).^2));
[~,id]=max(ccos);
tmplt(:,tn)=Mx(:,id);
seedmap(idx(id))=1;

while tn<segn
    tmp=zeros(tn,len);
    for i=1:tn
        CY=repmat(tmplt(:,i),1,len);
        tmp(i,:)=sqrt(sum((Mx-CY).^2));
    end
    tn=tn+1;
    ccos=min(tmp);
    [~,id]=max(ccos);
    tmplt(:,tn)=Mx(:,id);
    seedmap(idx(id))=1;
end

cenInt=tmplt;
ccos=zeros(segn,len,'single');
flag=1;

while flag==1
    for i=1:segn
        CY=repmat(cenInt(:,i),1,len);
        ccos(i,:)=sqrt(sum((Mx-CY).^2));        
    end
    
    [~, clab]=min(ccos);
    NcenInt=zeros(dimn,segn,'single');
    
    for i=1:segn
        tmind=find(clab==i);
        tmp=Mx(:,tmind);
        NcenInt(:,i)=sum(tmp,2)./length(tmind);
    end

    d = abs(NcenInt-cenInt);
    if max(d(:))<.00001
        flag=0;
    else
        cenInt=NcenInt;
    end  
end

B=(NcenInt'*NcenInt)^(-1)*NcenInt'*Y1;
[~,slab]=max(B);

% Impose nonnegativity constraint
if NC==1
    w0=U1*NcenInt;
    w0(w0<0)=0;
    
    dnorm0 = 1e+5;
    for i=1:100
        %sprintf('iteration %d',i)
        h=max(0,(w0'*w0+eye(segn)*0.1)\(w0'*Y));
        w=max(0,(h*h'+eye(segn)*0.1)\(h*Y'));
        w=w';
        
        d = Y - w*h;
        dnorm = sqrt(sum(sum(d.^2))/(bb*N1*N2));
        
        % Check for convergence
        if i>1
            if abs(dnorm0-dnorm) <= 1e-2
                break;
            end
        end
        
        w0=w;
        dnorm0=dnorm;
    end
    [~,slab]=max(h);
end

SegLab=reshape(slab,N1,N2);



