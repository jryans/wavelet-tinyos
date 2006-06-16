function []=condcomp(numsens,field,condtargs)

% usage:    []=sspcomp(numsens,field,condtargs)
%
% compare update techniques using requested (UPMUMS)
% vector of numbers of udpate neighbors...
% 
% input:        numsens     -   number of sensors
%               field       -   field type
%               condtargs   -   vector of target condition 
%                               numbers
%
% output:       (none)
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/19/05

close all;

errvecs=struct([]);
residvecs=struct([]);
countvecs=struct([]);
trancondvec=zeros(size(condtargs));

[coords,vals]=fieldgen(numsens,field,'irreg');

for k=1:length(condtargs)
    
    [tranvals,scales,predneighbs,predfilts,upneighbs,upfilts,trancond]=itlift_meshless(coords,vals,Inf,condtargs(k));

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
    resid=zeros(size(coeffcount));
	
	for i=1:length(coeffcount)        
        kept=find(abs(wavcoeffs).*2.^(-wavscales)>=wavmags(i));
        lost=complement([1,1:length(wavcoeffs)],kept);
        wavcoeffshat=zeros(size(wavcoeffs));
        wavcoeffshat(kept)=wavcoeffs(kept);
        tranvalshat=zeros(size(tranvals));
        tranvalshat(scalesens)=tranvals(scalesens);
        tranvalshat(wavsens)=wavcoeffshat;
        valshat=itrecon_meshless(tranvalshat,scales,predneighbs,predfilts,upneighbs,upfilts);
        err(i)=sum((vals-valshat).^2);
        resid(i)=sum(wavcoeffs(lost).^2);
        coeffcount(i)=length(kept);
	end
	coeffcount=coeffcount+length(scalesens);
    err=err/numsens;
    resid=resid/numsens;
    
    errvecs{k}=err;
    residvecs{k}=resid;
    countvecs{k}=coeffcount;
    trancondvec(k)=trancond;
    
end

for k=1:length(condtargs)
    disp(['condtarg = ' num2str(condtargs(k)) ', trancond = ' num2str(trancondvec(k))]);
end

save CONDCOMPDEBUG

plotcolors=['-b';'-r';'-g';'-c';'-m';'-y';'-k'];
if length(condtargs)>length(plotcolors) error('not enough plot symbols'); end

figure; hold on;
legstr=[];
for k=1:length(condtargs)
    plot(countvecs{k},errvecs{k},plotcolors(k,:));
    if k==1
        legstr=[legstr '''' num2str(condtargs(k)) ''','];
    elseif k<length(condtargs)
        legstr=[legstr '''' num2str(condtargs(k)) ''','];
    else
        legstr=[legstr '''' num2str(condtargs(k)) ''''];
    end
end
eval(['legend(' legstr ');']);
title('MSE vs. Coefficient Count for Different Target Condition Numbers');
xlabel('coefficient count');
ylabel('MSE');

figure; 
for k=1:length(condtargs)
    semilogy(countvecs{k},errvecs{k},plotcolors(k,:));
    if k==1 hold on; end;
end
eval(['legend(' legstr ');']);
title('MSE vs. Coefficient Count for Different Target Condition Numbers');
xlabel('coefficient count');
ylabel('MSE');

for k=1:length(condtargs)
    figure; hold on;
    plot(countvecs{k},errvecs{k},'r-');
    plot(countvecs{k},residvecs{k},'b-');
    legend('err','resid');
    title(['residual & error comparison, cond targ = ' num2str(condtargs(k))]);
    xlabel('coefficient count');
    ylabel('MSE, MSR');
end
    
