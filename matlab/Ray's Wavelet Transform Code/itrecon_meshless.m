function [vals]=itrecon_meshless(tranvals,scales,predneighbs,predfilts,upneighbs,upfilts)

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

for j=startscale+1:1:endscale
    decj=find(scales==j);
    % first, undo update...
    for m=1:length(decj)
        decm=decj(m);
        upneighbsm=upneighbs{decm};
        vals(upneighbsm)=vals(upneighbsm)-upfilts{decm}*tranvals(decm);
    end
    % now, undo predict...
    for m=1:length(decj)
        decm=decj(m);
        predneighbsm=predneighbs{decm};
        vals(decm)=tranvals(decm)+predfilts{decm}*vals(predneighbsm,1);
   end
end
        