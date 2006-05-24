function [smoothed,upneighbs,upfilts]=upstep(numup,dec,unsmoothed,diffs,oldints,newints,predneighbs,coords)

% usage:    [smoothed,upneighbs,upfilts]=upstep(numup,dec,unsmoothed,diffs,oldints,newints,predneighbs,coords)
%
% given indices DEC indicating predicted sensor nodes and a number NUMUP
% indicating how many of each predicted node's neighbors should be updated,
% update the requested number of neighbors (in struct PREDNEIGHBS) for each 
% node in DEC using their old, unsmoothed values in UNSMOOTHED, the new wavelet 
% coefficients in DIFFS, old and new scaling function integrals in OLDINTS and 
% NEWINTS 
% 
% input:        numup       - number of predicted neighbors to update.  for
%                             planar regression predict, can either be 0,1,2,3 or Inf 
%                             (to update all neighbors)
%               dec         - indices of predicted/decimated nodes
%               unsmoothed  - 1xNUMSENS vector of unsmoothed data values (NaN for all 
%                             gridpoints predicted at the current and finer scales)
%               diffs       - 1xNUMSENS vector of predicted values (NaN for all 
%                             gridpoints not indexed by DEC)
%               oldints     - 1xNUMSENS vector of old scaling function integrals (NaN 
%                             for all indices predicted at finer scales)
%               newints     - 1xNUMSENS vector of new scaling function integrals (NaN 
%                             for all indices in predicted at current or finer scales)
%               predneighbs - struct indexed by indices in DEC and containing neighbor 
%                             indices used in each predicted node's prediction
%               coords      - NUMSENSx2 list of node coordinates 
%
% output:       smoothed    - 1xNUMSENS vector of smoothed sensor values after update 
%                             (NaN for all indices predicted at current and finer scales)
%               predneighbs - struct indexed by node indices containing neighbor indices 
%                             used in each predicted node's update of those neighbors 
%               predfilts   - struct indexed by node indices containing predict filter 
%                             coefficients used in each pedicted node's update of those
%                             neighbors 
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/17/05

upneighbs=struct([]);
upfilts=struct([]);

% since all udpate is additive, initialize smoothed with unsmoothed
% values...
smoothed=unsmoothed;

for i=1:length(dec)
    neighbsi=predneighbs{dec(i)};
    distsi=sqrt((coords(neighbsi,1)-coords(dec(i),1)).^2+(coords(neighbsi,2)-coords(dec(i),2)).^2);
    [distsi,sortinds]=sort(distsi);
    neighbsi=neighbsi(sortinds);
    if (numup~=inf)  neighbsi=neighbsi(1:numup);  end
    upfiltsi=newints(neighbsi)*oldints(dec(i))/sum(newints(neighbsi).^2);
    smoothed(neighbsi)=smoothed(neighbsi)+upfiltsi*diffs(dec(i));
    upneighbs{dec(i)}=neighbsi;
    upfilts{dec(i)}=upfiltsi;
end
    
    
    
    