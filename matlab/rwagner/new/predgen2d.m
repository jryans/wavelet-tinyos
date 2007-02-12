function [predneighbs,predcoeffs,newints,mchange]=predgen2d(dec,coarse,ints,coords,j,polyord)

% usage:
% [predneighbs,predcoeffs,newints,mchange]=predgen2d(dec,co
% arse,ints,coords,j,polyord)
%
% given indices DEC into a 1xNUMSENS list of node coordinates, compute 
% wavelet lifting predict coefficients  for each of the nodes lambda in DEC 
% by regressing an order-m polynomial through the lambda'a neighbors in 
% COARSE within CL*2^-j ball of lambda (m=0 for constant, m=1 for plane the
% only orders currently supported).  also update scaling function
% integrals for points in COARSE to account for the effects of the predict 
% stage. 
% 
% input:        dec         - indices of nodes to be predicted
%               coarse      - indices of nodes to remain in the coarse grid
%               ints        - 1xNUMSENS vector of scaling function
%                             integrals (NaN for indices not in DEC or 
%                             COARSE)
%               coords      - NUMSENSx2 list of node coordinates
%               j           - transform scale
%               polyord     - order of polynomial to regress to neighbors
%                             (can be 0 for constant, 1 for plane)
%
% output:       newints     - 1xNUMSENS vector of new scaling function
%                             integrals (NaN for indices not in COARSE)
%               predneighbs - struct indexed by node indices containing
%                             neighbor indices used in each predicted
%                             node's prediction 
%               predfilts   - struct indexed by node indices containing
%                             predict filter coefficients used in each 
%                             predicted node's prediction
%               mchange     - indicator variable for estimating
%                             quasi-uniformity of mesh at current scale
%                             of prediction.  0 if mesh behaves as a
%                             quasi-uniform one (stable order-m predict
%                             found with points in CL*2^-j ball), 1
%                             otherwise (order rediced to m-1 at some 
%                             lambda in DEC). 
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  7/29/2006

predneighbs=struct([]);     % struct to hold predict neighbors
predcoeffs=struct([]);       % struct to hold predict filter coefficient

mchange=boolean(0);     % for now, assume order-POLYORD quasi-uniform mesh

for i=1:length(dec)    
    %fprintf \t; disp(['sensor ' num2str(i) ' of ' num2str(length(dec)) '...']);
    % first sort coarse points by distance to decimated point...
    xdists=coords(coarse,1)-coords(dec(i),1);
    ydists=coords(coarse,2)-coords(dec(i),2);
    dists=sqrt(xdists.^2+ydists.^2);
    [dists,sortind]=sort(dists);
    xdists=xdists(sortind);  ydists=ydists(sortind);
    neighbs=coarse(sortind);   
    
    for m=polyord:-1:0
        [pneighbsm,pcoeffsm]=polyreg(m,j,dec(i),coords,dists,xdists,ydists,neighbs);
        if ~isempty(pneighbsm)
            predneighbs{dec(i)}=pneighbsm;
            predcoeffs{dec(i)}=pcoeffsm;
            break;  % order-m coefficients found; terminate the loop
        end
    end
    if m<polyord  
        % mesh not quasi-uniform for order-POLYORD approximation
        mchange=boolean(1);
    end
        
end
    
% finally, calculate the new integrals...
newints=NaN*ones(size(ints));
newints(coarse,1)=ints(coarse,1);
for i=1:length(dec)
    newints(predneighbs{dec(i)},1)=newints(predneighbs{dec(i)},1)+predcoeffs{dec(i)}'*ints(dec(i),1);
end


%*************************************************************
% new function: POLYREG
% compute the minimum MSE regression of an order-m polynomial 
% through points in a neighborhood of CL*2^(-j) from a point 
% lambada.  return the neighbors used for the regression and
% the coefficients used in the linear combination of their
% measurement values to compute the regression at lambda...
%
% usage:
% [regneighbs,regcoeffs]=polyreg(m,j,lambda,coords,dists,xdists,ydists,neighbs);
%
% input:
%           m       -   order of plane to regress
%           j       -   scale of wavelet transform
%           lambda  -   index for central point of regression
%           coords  -   coordinates of all points in set
%           dists   -   euclidean distances of neighbors from lambda
%                       (sorted in increasing order)
%           xdists  -   sorted x-distances of neighbors from lambda
%           ydists  -   sorted y-distances of neighbors from lambda
%           neighbs -   sorted neighbor indices
%
% output:
%           regneighbs  -   neighbors used in regression
%           regcoeffs   -   coefficients used to regress plane
%                           through neighbors' measurements at lambda
%
% NEIGHBS,COEFFS=[] if regression of proper stability not
% attainable...

function [regneighbs,regcoeffs]=polyreg(m,j,lambda,coords,dists,xdists,ydists,neighbs);

% set CA, CL
switch m
    case 0
        CL=1; CA=1;
    case 1
        CL=4; CA=2;
    otherwise
        error(['order-' num2str(m) ' prediction not supported...']);
end

inrad=find(dists<=(CL*2^(-j)));
dists=dists(inrad); xdists=xdists(inrad); ydists=ydists(inrad);
neighbs=neighbs(inrad);

regneighbs=[];
regcoeffs=[];

switch m
    % constant regression - pick the closest neighbor, with coefficient 1
    case 0      
        regneighbs=neighbs(1);
        regcoeffs=1;
    
    % planar regression - pick some increasing-discance subset of neighbors 
    % (minimum size 3) such that the absolute sum of coefficients is 
    % minimum
    case 1
        N=length(neighbs);
        %fprintf \t; fprintf \t; disp(['N = ' num2str(N)]);
        h=CL*2^(-j);
        combs=struct([]);
        combdists=[];
        % consider all combinations NCk for k<=N.  for 
        % each k, compute the total squared distance to
        % all sensors, and sort the NCk according to 
        % this.  then go through these, looking for a combination whose
        % coefficients have an absolute sum <=Ca.  chose this set of 
        % coefficients and terminate the loop.  suboptimal since it
        % only computes the energy estimate k-at-a-time, but unlike the
        % full combinatorial approach, is actually tractable.  
        for k=3:N
            for m=1:combin2(N,k)
                combm=comb_unrank(N,k,m);
                combdists=[combdists,sum(dists(combm).^2)];
                combs{length(combdists)}=combm;
            end
            [combdists,combinds]=sort(combdists);
        
            regneighbs=[];
            regcoeffs=[];
            for i=1:length(combinds)      
                neighbsi=neighbs(combs{combinds(i)});
                X=[ones(length(neighbsi),1),(coords(neighbsi,1)-coords(lambda,1))/h,...
                    (coords(neighbsi,2)-coords(lambda,2))/h];
                coeffsi=[1,0,0]*inv(X'*X)*X';
                Cai=sum(abs(coeffsi));
                if Cai<=CA
                    regneighbs=neighbsi;
                    regcoeffs=coeffsi;
                    break;
                end
            end
            if ~isempty(regneighbs)
                break;
            end
        end
        
     % NOTE: fairly easy to implement regression for arbitrary m by simply
     % generating an order-m X matrix...
end
  


       