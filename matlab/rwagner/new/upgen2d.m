function [upneighbs,upcoeffs]=upgen2d(uptype,dec,oldints,newints,predneighbs,coords)

% usage:    [upneighbs,upcoeffs]=upstep(uptype,dec,oldints,newints,predneighbs,coords)
%
% given indices DEC indicating predicted sensor nodes and a number NUMUP
% indicating how many of each predicted node's neighbors should be updated,
% update the requested number of neighbors (in struct PREDNEIGHBS) for each 
% node in DEC using their old, unsmoothed values in UNSMOOTHED, the new wavelet 
% coefficients in DIFFS, old and new scaling function integrals in OLDINTS and 
% NEWINTS 
% 
% input:        uptype      - update type requested.  can be 'ls',
%                             least-squares update of all predicted 
%                             neighbors (default), or 'closest', updating 
%                             single closest predicted neighbor,
%                             or 'none' for a predict-only transform.
%               dec         - indices of predicted/decimated nodes
%               oldints     - 1xNUMSENS vector of old scaling function integrals (NaN 
%                             for all indices predicted at finer scales)
%               newints     - 1xNUMSENS vector of new scaling function integrals (NaN 
%                             for all indices in predicted at current or finer scales)
%               predneighbs - struct indexed by indices in DEC and containing neighbor 
%                             indices used in each predicted node's prediction
%               coords      - NUMSENSx2 list of node coordinates 
%
% output:       predneighbs - struct indexed by node indices containing neighbor indices 
%                             used in each predicted node's update of those neighbors 
%               predfilts   - struct indexed by node indices containing predict filter 
%                             coefficients used in each pedicted node's update of those
%                             neighbors 
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  7/29/2006

numsens=size(coords,1);

upneighbs=struct([]);
upcoeffs=struct([]);
for n=1:numsens
    upneighbs{n}=[];
    upcoeffs{n}=[];
end

for i=1:length(dec)
    neighbsi=predneighbs{dec(i)};
    distsi=sqrt((coords(neighbsi,1)-coords(dec(i),1)).^2+(coords(neighbsi,2)-coords(dec(i),2)).^2);
    [distsi,sortinds]=sort(distsi);
    neighbsi=neighbsi(sortinds);
    switch uptype
        case 'ls'
            upfiltsi=newints(neighbsi)*oldints(dec(i))/sum(newints(neighbsi).^2);
        case 'closest'
            neighbsi=neighbsi(1,1);
            upfiltsi=oldints(dec(i))/newints(neighbsi);
        case 'none'
            % no update...
            neighbsi=[];
            coeffsi=[];
        otherwise
            error('unsupported update type requested...');
    end      
    for n=1:length(neighbsi)
        upneighbs{neighbsi(n)}=[upneighbs{neighbsi(n)},dec(i)];
        upcoeffs{neighbsi(n)}=[upcoeffs{neighbsi(n)},upfiltsi(n)];
    end
end