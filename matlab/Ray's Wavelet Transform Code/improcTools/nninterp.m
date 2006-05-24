function  [interp] = nninterp(rows,cols,vals,numNeigh,intRows,intCols)

% usage: [interp] = nninterp(rows,cols,vals,numNeigh,intRows,intCols)
% 
% Given a non-uniform samping of a grid as a lists of (row,column) 
% coordinates and their cooresponding values, a uniform 
% INTROWS X INTCOLS grid is interpolated as a weighted (inverse
% distance) sum of the NUMNEIGH nearest non-uniformly sampled
% points.  
% 
% input:    rows     - row positions of non-uniform sample points
%           cols     - column positions of non-uniform sample points
%           vals     - values of non-uniform sample points
%           numNeigh - number of nearest neighbors to use for 
%                      interpolation
%           intRows  - number of rows requested in interpolated 
%                      image
%           intCols  - number of columns requested in interpolated 
%                      image
%           
% return:   interp   - interpolated INTROWS X INTCOLS image
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University, 
% Raytheon Missile Systems (unclassified)
% last rev: 7/24/03

interp=zeros(intRows,intCols);

for i=1:intRows
    disp(['calculating value of row ' num2str(i)]);
    for j=1:intCols 
        % compute distances
        dists=((rows-i).^2+(cols-j).^2).^(1/2); 
        if sum(dists==0)<0
            disp([dists'; vals']);
        end
        
        % randomly permute distances such that distance
        % sort unbiased to order of values of equal distance        
        perm=randperm(length(dists));
        distsPerm=dists(perm);
        valsPerm=vals(perm);
        
        % now interpolate by choosing NUMNEIGH closest values
        % to the (i,j) gridpoint and weighting appropriately        

        iszero=(distsPerm==0);        
        if sum(iszero)>0  % values falling exactly on gridpoints        
            zcount=sum(iszero);
            interp(i,j)=sum(valsPerm(iszero))/zcount;
        else
            [sortDists,order]=sort(distsPerm);
            sortVals=valsPerm(order);
            weights=1./sortDists(1:numNeigh);
            interp(i,j)=sortVals(1:numNeigh)'*weights/sum(weights);
        end
        
    end
end
        
        
      
    
