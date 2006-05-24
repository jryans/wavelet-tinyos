function [newdec, newcoarse, predvals, newints, predneighbs, predfilts]=predstep(dec, coarse, vals, ints, coords, condtarg)

% usage:    [newdec, newcoarse, predvals, newints, predneighbs, predfilts]=predstep(dec, coarse, vals, ints, coords, condtarg)
%
% given indices DEC into a 1xNUMSENS list of node coordinates, predict values at each of the nodes 
% in DEC by regressing a plane through the nodes' neighbors in COARSE.  return in PREDVALS for each 
% predicted node the difference between each node's original value in VALS and the value predicted 
% by regression.  given scaling function integrals for nodes in [DEC,COARSE], return integrals for the
% scaling functions corresponding to nodew in NEWCOARSE. neighbors for prediction are chosen in order 
% of distance from the predicted sensor to achieve a target condition number on the regression matix....
% 
% input:        dec         - indices of nodes to be predicted
%               coarse      - indices of nodes to remain in the coarse grid
%               vals        - 1xNUMSENS vector of node values (NaN for
%                             already-predicted nodes)
%               ints        - 1xNUMSENS vector of scaling function
%                             integrals (NaN for indices not in DEC or COARSE)
%               coords      - NUMSENSx2 list of node coordinates
%               condtarg    - target condition number for the regression (for 
%                             reference, inversion on the interior of a decimated, 
%                             regular square grid has condition number of 2 or 5, 
%                             depending on the location of the decimated point)...
%
% output:       newdec      - new list of predcted sensor indices
%               newcoarse   - new list of sensor indices at the next coarsest
%                             scale
%               predvals    - 1xNUMSENS vector of predicted values
%               newints     - 1xNUMSENS vector of new scaling function
%                             integrals (NaN for indices not in NEWCOARSE)
%               predneighbs - struct indexed by node indices containing
%                             neighbor indices used in each predicted
%                             node's prediction 
%               predfilts   - struct indexed by node indices containing
%                             predict filter coefficients used in each 
%                             predicted node's prediction
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/19/05

predneighbs=struct([]);                   % struct to hold predict neighbors
predfilts=struct([]);                     % struct to hold predict filter coefficient
predvals=NaN*ones(size(coords,1),1);      % vector to hold predicted neighbors
unpred=[];                                % vector to hold indices of unpredictable nodes

for i=1:length(dec)    
    % first sort coarse points by distance to decimated point...
    xdists=coords(coarse,1)-coords(dec(i),1);
    ydists=coords(coarse,2)-coords(dec(i),2);
    dists=sqrt(xdists.^2+ydists.^2);
    [dists,sortind]=sort(dists);
    xdists=xdists(sortind);  ydists=ydists(sortind);
    neighbs=coarse(sortind);
    
    % starting with three neighbors, expand the search radius h until
    % enough neighbors are found that the target condition number on 
    % inverting the regression matrix is met...
    for j=3:length(dists)
        
        xdistsj=xdists(1:j);
		ydistsj=ydists(1:j);
		distsj=dists(1:j);
        numneighbs=j;
		h=max(distsj);
		
		G=[numneighbs,     sum(xdistsj/h),            sum(ydistsj/h);
           sum(xdistsj/h), sum(xdistsj.^2/h^2),       sum(xdistsj.*ydistsj/h^2);
           sum(ydistsj/h), sum(xdistsj.*ydistsj/h^2), sum(ydistsj.^2/h^2)];
       
       % if the target is met, save the list of neighbors used in the struct
       % PREDNEIGHBS, and calculate the prediction coefficient, storing it
       % in vector predvals...
       if cond(G)<condtarg
            valsj=vals(neighbs(1:j),1);
            fvec=[sum(valsj); sum(valsj.*xdistsj/h); sum(valsj.*ydistsj/h)];
            regcoeffs=inv(G)*fvec;
            
            % re-formulate the regression as a predict filter on values at 
            % neighboring sensors...
            X=[ones(j,1),(coords(neighbs(1:j),1)-coords(dec(i),1))/h,(coords(neighbs(1:j),2)-coords(dec(i),2))/h];
            pfiltj=[1,0,0]*inv(X'*X)*X';
            pvalj=pfiltj*valsj;
            if ~(abs(pvalj-regcoeffs(1))<1e-10)
                save REGDEBUG
                error('regression methods do not match...');
            end            
            % since the plane is regressed about DEC(i), the plane value at
            % that point is only the constant value (first filter coefficient in
            % REGCOEFFS). alculate the prediction coefficient as the
            % difference between this and the value at DEC(i) in VALS...
            predvals(dec(i))=vals(dec(i))-pvalj; 
            
            % store the predict neighbor indices and filter in the
            % appropriate structs...            
            predneighbs{dec(i)}=neighbs(1:j);
            predfilts{dec(i)}=pfiltj;
            break;            
        elseif j==length(dists)
            % all neighbors used, and conditioning still poor. mark DEC(i)
            % as unpredictable...
            unpred=[unpred, dec(i)];
        end
    end
end
    
% remove unpredictable points from the decimated list and add them
% back to the coarse grid list...
newdec=complement(dec,unpred);
newcoarse=[coarse, unpred];

% finally, calculate the new integrals...
newints=NaN*ones(size(ints));
newints(newcoarse,1)=ints(newcoarse,1);
for i=1:length(newdec)
    save ERRDEBUG
    newints(predneighbs{newdec(i)},1)=newints(predneighbs{newdec(i)},1)+predfilts{newdec(i)}'*ints(newdec(i),1);
end

% use to debug:
% 
% load PSTEPTEST
% psen=13; 
% dists=sqrt((coords(coarse,1)-coords(psen,1)).^2+(coords(coarse,2)-coords(psen,2)).^2); 
% [dists,sortind]=sort(dists); sortcoarse=coarse(sortind)
% 
% condG=condstudy(coords)
% 
% pneighbs=[5,10,6];
% xdists=coords(pneighbs,1)-coords(psen,1); 
% ydists=coords(pneighbs,2)-coords(psen,2); 
% h=max(sqrt(sum(xdists.^2+ydists.^2))); 
% G=[length(pneighbs), sum(xdists/h), sum(ydists/h); sum(xdists/h), sum(xdists.^2/h^2), sum(xdists.*ydists/h^2); sum(ydists/h), sum(xdists.*ydists/h^2), sum(ydists.^2/h^2)];
% alpha=inv(G)*[sum(vals(pneighbs)); sum(vals(pneighbs).*xdists/h); sum(vals(pneighbs).*ydists/h)]; 
% vals(psen)-alpha(1)

    
       