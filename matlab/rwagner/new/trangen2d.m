function [trandata]=trangen2d(coords,m,uptype);

% usage:    [trandata]=trangen2d(coords);
%
% for a list of NUMSENS 2-D coordinates, generate wavelet lifting
% transform parameters for the transform described in "Approximation
% and Compression of Scattered Data by Meshless Multiscale Decompositions"
% (Barankiuk, Cohen, and Wagner).   
% 
% input:        coords      -   NUMSENSx2 list of 2-D coordinates.   
%
% (optional)    m           -   prediction order. only m=0 for constant,
%                               m=1 for planar (defualt) supported.
%               uptype      -   update type requested.  can be 'ls',
%                               least-squares update of all predicted 
%                               neighbors (default), 'closest', 
%                               updating single closest predicted neighbor,
%                               or 'none' for a predict-only transform.
%
% output:       (output variables stored in struct TRANDATA,
%               formatted as follows...)
%
%               scales      -   NUMSENSx1 vector indicating scale of each 
%                               point's wavelet coefficient. (trandata{1})
%               predneighbs -   struct of NUMSENS elements, each a list of
%                               node ID's of neighbors used by node n to                                                 
%                               compute its wavelet coefficient. 
%                               (trandata{2})
%               predcoeffs  -   struct matching predneighbs containing
%                               predict coefficient for each neighbor.
%                               (trandata{3})
%               upneighbs    -  struct of NUMSENS elements, each a struct
%                               of J elements where J=max(scales). 
%                               upneighbs{n}{j} gives the neighbors which 
%                               update node n at scale j --- i.e., those
%                               neighbors node n helps predict.
%                               (trandata{4})
%               upcoeffs    -   struct matching upneighbs containing update
%                               coefficient for each neighbor.
%                               (trandata{5})
%               W           -   overall transform matrix, which implements
%                               all sclaes of the lifting transform with a
%                               single matrix multiply. (trandata{6})
%               estL        -   first scale at which Theorem 3.1 holds
%                               true --- i.e. estimate of scale of first 
%                               quasi-uniform mesh. (trandata{7})
%                               
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  8/04/06

numsens=size(coords,1);

if nargin==1    % no prediction order, update type specified
    m=1;
    uptype='ls';
end    

if nargin==2    % no update type specified
    uptype='ls';
end

predneighbs=struct([]); 
predcoeffs=struct([]); 
for i=1:numsens
    predneighbs{i}=[];
    predcoeffs{i}=[];
end

upneighbs=struct([]); 
upcoeffs=struct([]);

% extract the minimum distance and compute the starting scale J
mindist=inf;
for i=1:numsens
    for j=1:numsens
        if i~=j
            distij=sqrt((coords(i,1)-coords(j,1))^2+(coords(i,2)-coords(j,2))^2);
            mindist=min([distij,mindist]);
        end
    end
end 
startj=-ceil(log2(mindist));

for j=1:startj
    upneighbs{j}=NaN;
    upcoeffs{j}=NaN;
end
    
scales=NaN*ones(numsens,1);

% intitialize a vector to contain order-reduction
% indicator variables for each scale...
ordred=boolean(ones(startj,1));

figdisp=0;      % flag to trigger figure display...
printmsg=0;     % flag to trigger message printing...

% initialize the initial finer-scale grid with all the nodes...
gridj=[1:numsens];
if figdisp
	figure; hold on; 
	for i=1:length(gridj) 
        plot(coords(gridj(i),1),coords(gridj(i),2),'*'); 
        text(coords(gridj(i),1),coords(gridj(i),2)-0.01,num2str(gridj(i)));
	end
	title('original grid');
end

% initialize a variable to hold j for the coarsest 
% scale (scaling coefficients)...
coarsej=[];

% intitialize the finest-scale scaling function integrals
% as dirac deltas at the sample points...
ints=ones(numsens,1);

for j=startj:-1:1    
    if printmsg
        disp(['scale ' num2str(j) '....']);
    end
    % decimate based on proximity...
    dec=[];    
    nextind=1;        
    while nextind<=length(gridj)
        next=gridj(nextind);
        other=complement(gridj,next);        
        coarsedists=sqrt((coords(next,1)-coords(other,1)).^2+(coords(next,2)-coords(other,2)).^2);        
        closepts=other(coarsedists<2^-j);
        
        dec=[dec, closepts];
        gridj=complement(gridj,closepts);       
        nextind=find(gridj==next)+1;
    end   
    
    %disp(['scale-' num2str(j) ' predict...']);
    [predneighbsj,predcoeffsj,newintsj,mchange]=predgen2d(dec,gridj,ints,coords,j,m);
    if j~=0
        ordred(j)=mchange;
    end
    
    % set L as the first scale where the order-m predict is successful...
    % (not the best of all approximations, and still a bit buggy...)
    if ordred==1 & ~mchange & ~isempty(dec)
        estL=j;
        ordred=0;
    end

    % don't try to predict with fewer than 3 coarse grid points...
    if length(gridj)<3
        % restore decimated points to the final-scale grid...
        gridj=[gridj,dec];
        % set the scale of scaling coefficients to j
        coarsej=j;
        % ... and quit.
        break;
    end
    
    [upneighbsj,upcoeffsj]=upgen2d(uptype,dec,ints,newintsj,predneighbsj,coords);        

    scales(dec)=j;
    % PREDNEIGHBSJ, PREDFILTSJ, are returned as structs with 
    % NUMSENS elements, all of which save those corresponding 
    % to indices in DEC are empty...
    for i=1:length(dec)
        predneighbs{dec(i)}=predneighbsj{dec(i)};
        predcoeffs{dec(i)}=predcoeffsj{dec(i)};
    end    
    % UPNEIGHBSJ and UPCOEFFSJ are returned as structs with 
    % NUMSENS elements, with elements for non-updated sensors
    % set to NaN...
    upneighbs{j}=upneighbsj;
    upcoeffs{j}=upcoeffsj;
           
    if figdisp
        figure; hold on;
        for i=1:length(gridj)
            plot(coords(gridj(i),1),coords(gridj(i),2),'b*');
            text(coords(gridj(i),1),coords(gridj(i),2)-0.01,num2str(gridj(i)));
        end
        for i=1:length(dec)
            plot(coords(dec(i),1),coords(dec(i),2),'r*');
            text(coords(dec(i),1),coords(dec(i),2)-0.01,num2str(dec(i)));
        end
        axis([0,1,0,1]);
        title(['scale ' num2str(j) ' grid']);   
    end  
    ints=newintsj;
end

% if the for loop ran to completion (was not broken before j=1),
% set the scale of scaling coefficients now...
if isempty(coarsej)
    coarsej=j-1;
end
% fill in the scales for the scaling coefficients
scales(gridj)=coarsej;

% disp(['old coarsej = ' num2str(coarsej)]);

% now, go through and remove the small scales (should be at most
% scale COARSEJ+1) which have reverted to order m-1 approximation...
while ordred(coarsej+1)
    oldcoarse=find(scales==coarsej);
    oldnext=find(scales==(coarsej+1));
    
    % go through and remove scale-(coarsej+1) predicts...
    for n=1:length(oldnext)
        predneighbs{oldnext(n)}=[];
        predcoeffs{oldnext(n)}=[];
    end
    % now go through and remove all scale-(coarsej+1)
    % updates...
    for n=1:length(oldcoarse)
        upneighbs{coarsej+1}{oldcoarse(n)}=[];
        upcoeffs{coarsej+1}{oldcoarse(n)}=[];
    end
   % finally, set the new coarse scale and 
   % update the scale vector accordingly... 
   coarsej=coarsej+1;
   scales([oldcoarse;oldnext])=coarsej;
end

% disp(['fixed coarsej = ' num2str(coarsej)]);

% finally, set the estimate of the first quasi-uniform
% scale of the mesh...
for j=coarsej+1:startj
    if j==startj & ordred(j)
        estL=NaN;   % there are no quasi-uniform scales
    elseif j==startj & ~ordred(j)
        estL=j;     % all scales are quasi-uniform
    elseif ~ordred(j)&ordred(j+1)
        estL=j;     % scales coarsej+1 through j are quasi-uniform
        break;
    end
end

% finally, assemble the matrix describing the overall transform, and
% compute its condition number....
W=eye(numsens);

startj=max(scales);
endj=min(scales)+1;

Ie=struct([]);
Io=struct([]);

for j=startj:-1:endj
    predj=find(scales==j);
    upj=find(scales<j);
    Pj=zeros(numsens,numsens);
    Uj=zeros(numsens,numsens);
    for k=1:length(predj)
        Pj(predj(k),predneighbs{predj(k)})=predcoeffs{predj(k)};
    end
    for n=1:numsens 
        if ~isnan(upneighbs{j}{n})
            Uj(n,upneighbs{j}{n})=upcoeffs{j}{n};
        end
    end
             
    Iej=zeros(numsens,numsens); Ioj=zeros(numsens,numsens);
    for k=1:length(upj) Iej(upj(k),upj(k))=1; end
    for k=1:length(predj) Ioj(predj(k),predj(k))=1; end
    Ie{j}=Iej; Io{j}=Ioj;
    Wj=Iej+(eye(numsens)+Uj)*(Ioj-Pj);
    for k=j+1:1:startj
        Wj=Wj+Io{k};
    end
    W=Wj*W;
end

trandata=struct([]);
trandata{1}=scales;
trandata{2}=predneighbs;
trandata{3}=predcoeffs;
trandata{4}=upneighbs;
trandata{5}=upcoeffs;
trandata{6}=W;
trandata{7}=estL;
