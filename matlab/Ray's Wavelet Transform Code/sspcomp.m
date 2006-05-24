function []=sspcomp(numsens,field)

% usage:    []=sspcomp(numsens,field)
%
% need help entry
% 
% input:        numsens     -   number of sensors
%
% output:       (none)
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/07/05

close all;

[coords,vals]=fieldgen(numsens,field,'irreg');
[tranvals,scales,predneighbs,predfilts,upneighbs,upfilts]=itlift_meshless(coords,vals);

scalesens=find(scales==min(scales));
wavsens=complement([1:numsens],scalesens);

% extract wavelet coefficients:
wavcoeffs=tranvals(wavsens);
wavscales=scales(wavsens);
% now normalize wavelet coefficient magnitudes
% by scale (2^-j), and sort them to establish
% decimation order...
wavmags=abs(wavcoeffs).*2.^(-wavscales);
wavmags=sort(wavmags);
wavmags=[wavmags;Inf];

coeffcount=zeros(1,length(wavmags));
err=zeros(size(coeffcount)); 

for i=1:length(coeffcount)
    kept=find(abs(wavcoeffs).*2.^(-wavscales)>=wavmags(i));
    wavcoeffshat=zeros(size(wavcoeffs));
    wavcoeffshat(kept)=wavcoeffs(kept);
    tranvalshat=zeros(size(tranvals));
    tranvalshat(scalesens)=tranvals(scalesens);
    tranvalshat(wavsens)=wavcoeffshat;
    valshat=itrecon_meshless(tranvalshat,scales,predneighbs,predfilts,upneighbs,upfilts);
    err(i)=sum((vals-valshat).^2);
    coeffcount(i)=length(kept);
end
coeffcount=coeffcount+length(scalesens);

% *********************************************************
% section to compute SSP mesh-based transform approximation
% *********************************************************


[trandata,scalecoeffsold,wavcoeffsold]=itlift_CENT([1:numsens],coords,vals,'U1');

% first, build up a vector of scales to correspond to WAVCOEFFSOLD - note
% that scales as used here are the reverse of struct order in TRANDATA...
scalesold=[];
% must reverse scale labels from old transform to
% compare to new one...
scalevec=[length(trandata)-1:-1:1];   
for j=1:length(trandata)-1
    scalesold=[scalesold; j*ones(length(trandata{scalevec(j)}{1}),1)];
end

% sort coefficient magnitudes in descending order...
% coeffmagsold=abs(wavcoeffsold).*2.^(-scalesold);
coeffmagsold=abs(wavcoeffsold);

[coeffmagsold,magind]=sort(coeffmagsold);
coeffmagsold=flipud(coeffmagsold);
magind=flipud(magind);

% add a threshold above all wavelet coefficients...
coeffmagsold=[Inf;coeffmagsold];

coeffcountold=zeros(size(coeffmagsold));
errold=zeros(size(coeffmagsold));

for i=1:length(coeffmagsold)
%     if rem(i,10)==1
%         disp(['reconstructing with ' num2str(i-1) ' (of ' num2str(length(coeffmagsold)) ')...']);
%     end
    thresh=coeffmagsold(i);
    
    threshdata=coeffthresh(thresh,trandata);
    % threshdata=coeffthresh_scalemod(thresh,trandata);
    
    [senshat,valshat]=itrecon(threshdata);
    [senshat,sortind]=sort(senshat);
    valshat=valshat(sortind);
    errold(i)=sum((vals-valshat).^2);
    coeffcountold(i)=i-1;
end
coeffcountold=coeffcountold+length(scalecoeffsold);

figure;
plot(coeffcount,err/numsens,'-b');
hold on;  plot(coeffcountold,errold/numsens,'-r');
legend('meshless, l2 thresholding','mesh-based, l-inf thresholding');
xlabel('coefficient count');
ylabel('MSE');

figure; 
semilogy(coeffcount,err/numsens,'-b');
hold on;  semilogy(coeffcountold,errold/numsens,'-r');
legend('meshless, l2 thresholding','mesh-based, l-inf thresholding');
xlabel('coefficient count');
ylabel('MSE');


% *********************************************************
% section to compile stats about relative resource usage...
% *********************************************************

% first, aggregate average number of neighbors and average
% distance to neighbor per scale for the new technique:
avdists=NaN*ones(max(scales),1);
avneighbs=0;

for j=min(scales)+1:1:max(scales)
    nodesj=find(scales==j);
    distsj=0;
    numneighbsj=0;
    for k=1:length(nodesj)
        nodek=nodesj(k);
        neighbsk=predneighbs{nodek};
        numneighbsj=numneighbsj+length(neighbsk);
        distsj=distsj+sum(sqrt((coords(nodek,1)-coords(neighbsk,1)).^2+(coords(nodek,2)-coords(neighbsk,2)).^2));
    end
    avneighbs=avneighbs+numneighbsj;
    avdists(j)=distsj/numneighbsj;
end
avneighbs=avneighbs/length(wavsens);

% now, extract the same information for the old technique...
avdistsold=zeros(1,length(trandata)-1); 
avneighbsold=0;
senvec=trandata{length(trandata)}{1};
for j=length(trandata)-1:-1:1;
    nodesj=trandata{j}{1};
    senvec=sort([senvec,nodesj]);
    distsj=0;
    numneighbsj=0;
    for k=1:length(nodesj)
        nodek=nodesj(k);
        neighbsk=senvec(find(trandata{j}{3}(find(senvec==nodek),:)));
        numneighbsj=numneighbsj+length(neighbsk);
        distsj=distsj+sum(sqrt((coords(nodek,1)-coords(neighbsk,1)).^2+(coords(nodek,2)-coords(neighbsk,2)).^2));
    end
    avneighbsold=avneighbsold+numneighbsj;
    avdistsold(scalevec(j))=distsj/numneighbsj;
end
avneighbsold=avneighbsold/length(wavcoeffsold);

save SSPCOMPDEBUG
