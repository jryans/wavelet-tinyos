function []=predeval(numsens,field)

% usage:    []=itrecon(numsens,field)
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
[tranvals,scales,predneighbs,predfilts]=itlift_meshless(coords,vals);

scalesens=find(scales==min(scales));
wavsens=complement([1:numsens],scalesens);

% extract wavelet coefficients:
wavcoeffs=tranvals(wavsens);
% now sort them by magnitude to establish
% thresholds, adding an Inf to the end...
wavmags=sort(abs(tranvals(wavsens)));
wavmags=[wavmags;Inf];

coeffcount=zeros(1,length(wavmags));
err=zeros(size(coeffcount)); 

for i=1:length(coeffcount)
    kept=find(abs(wavcoeffs)>=wavmags(i));
    wavcoeffshat=zeros(size(wavcoeffs));
    wavcoeffshat(kept)=wavcoeffs(kept);
    tranvalshat=zeros(size(tranvals));
    tranvalshat(scalesens)=tranvals(scalesens);
    tranvalshat(wavsens)=wavcoeffshat;
    valshat=itrecon_meshless(tranvalshat,scales,predneighbs,predfilts);
    err(i)=sum((vals-valshat).^2);
    coeffcount(i)=length(kept);
end

figure; plot(coeffcount,err/numsens,'-b');
xlabel('coefficient count');
ylabel('MSE');

figure; semilogy(coeffcount,err/numsens,'-b');
xlabel('coefficient count');
ylabel('MSE');


save PREDEVALDEBUG


