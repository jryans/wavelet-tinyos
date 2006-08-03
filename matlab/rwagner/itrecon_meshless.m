function [vals,stepvals]=itrecon_meshless(tranvals,scales,predneighbs,predfilts,upneighbs,upfilts)

% usage:    [vals]=itrecon_meshless(tranvals,scales,predneighbs,predfilts,upneighbs,upfilts)
%
% need help entry
% 
% input:        numsens     -   number of sensors
%
% output:       (none)
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/17/05

numsens=length(tranvals);
vals=NaN*ones(size(tranvals));

startscale=min(scales);
endscale=max(scales);

gridj=find(scales==startscale);
vals(gridj)=tranvals(gridj);

stepvals(1,:) = tranvals;
for j=startscale+1:1:endscale
    decj=find(scales==j);
    % first, undo update...
    for m=1:length(decj)
        decm=decj(m);
        upneighbsm=upneighbs{decm};
        vals(upneighbsm)=vals(upneighbsm)-upfilts{decm}*tranvals(decm);
    end
    stepvals(j*2,:) = vals;
    nanvals = find(isnan(vals));
    for nc=1:size(nanvals)
        stepvals(j * 2, nanvals(nc)) = stepvals(j * 2 - 1, nanvals(nc));
    end
    % now, undo predict...
    for m=1:length(decj)
        decm=decj(m);
        predneighbsm=predneighbs{decm};
        vals(decm)=tranvals(decm)+predfilts{decm}*vals(predneighbsm,1);
    end
    stepvals(j*2+1,:) = vals;
    nanvals = find(isnan(vals));
    for nc=1:size(nanvals)
        stepvals(j * 2 + 1, nanvals(nc)) = stepvals(j * 2, nanvals(nc));
    end
end
       