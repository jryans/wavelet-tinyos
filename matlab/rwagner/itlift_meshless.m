function [tranvals,scales,predneighbs,predfilts,upneighbs,upfilts,tranmat]=itlift_meshless(coords,vals,numup,condtarg)

% usage:    [tranvals,scales,predneighbs,predfilts,upneighbs,upfilts,tranmat]=itlift_meshless(coords,vals,numup,condtarg)
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

close all;

numsens=size(coords,1);

if nargin==2    % no update number specified
    numup=Inf;      % update all
    condtarg=25;    % a reasonable condition number target
end    

tranvals=zeros(numsens,1);
predneighbs=struct([]); predfilts=struct([]); upneighbs=struct([]); upfilts=struct([]);
for i=1:numsens
    predneighbs{i}=[];
    predfilts{i}=[];
    upneighbs{i}=[];
    upfilts{i}=[];
end
scales=NaN*ones(numsens,1);

figdisp=0;      % flag to trigger figure display...
printmsg=0;     % flag to trigger message printing...

% extract the minimum distance...
mindist=inf;
for i=1:numsens
    for j=1:numsens
        if i~=j
            distij=sqrt((coords(i,1)-coords(j,1))^2+(coords(i,2)-coords(j,2))^2);
            mindist=min([distij,mindist]);
        end
    end
end

% extract the starting next-scale...
startj=-ceil(log2(mindist));

% initialize the initial finer-scale grid with all the nodes...
gridj=[1:numsens];
eval(['grid' num2str(startj+1) '=gridj;']);
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

for j=startj:-1:0    
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
    
    % don't try to predict with fewer than 3 coarse grid points...
    if length(gridj)<3
        % restore decimated points to the final-scale grid...
        gridj=[gridj,dec];
        % set the scale of scaling coefficients to j
        coarsej=j;
        % ... and quit.
        break;
    end
    
    [newdec, newgrid, diffsj, newintsj, predneighbsj, predfiltsj]=predstep(dec, gridj, vals, ints, coords, condtarg);

    unsmoothed=NaN*ones(size(vals)); unsmoothed(newgrid)=vals(newgrid);
    [smoothed,upneighbsj,upfiltsj]=upstep(numup,newdec,unsmoothed,diffsj,ints,newintsj,predneighbsj,coords);
    
    % for now, store everything as variables for debug
    eval(['ints' num2str(j) '=newintsj;']);
    eval(['diffs' num2str(j) '=diffsj;']);
    eval(['unsmoothed' num2str(j) '=unsmoothed;']);
    eval(['smoothed' num2str(j) '=smoothed;']);
    
    vals(newdec)=NaN;
    vals(newgrid)=smoothed(newgrid);
    tranvals(newdec)=diffsj(newdec);
    scales(newdec)=j;
    % PREDNEIGHBSJ, PREDFILTSJ, UPNEIGHBSJ, and UPFILTSJ are returned as structs with
    % NUMSENS elements, all of which save those corresponding to indices in NEWDEC are empty...
    for i=1:length(newdec)
        predneighbs{newdec(i)}=predneighbsj{newdec(i)};
        predfilts{newdec(i)}=predfiltsj{newdec(i)};
        upneighbs{newdec(i)}=upneighbsj{newdec(i)};
        upfilts{newdec(i)}=upfiltsj{newdec(i)};
    end    
      
    % print a message detailing which points could not be predicted...
    unpred=complement(dec,newdec);
    if ~isempty(unpred)&printmsg
        disp(['could not predict [ ' num2str(unpred) ' ] at scale ' num2str(j) '....']);
    end
    
    if figdisp
        figure; hold on;
        for i=1:length(newgrid)
            plot(coords(newgrid(i),1),coords(newgrid(i),2),'b*');
            text(coords(newgrid(i),1),coords(newgrid(i),2)-0.01,num2str(newgrid(i)));
        end
        for i=1:length(newdec)
            plot(coords(newdec(i),1),coords(newdec(i),2),'r*');
            text(coords(newdec(i),1),coords(newdec(i),2)-0.01,num2str(newdec(i)));
        end
        axis([0,1,0,1]);
        title(['scale ' num2str(j) ' grid']);  
    end
    
    gridj=newgrid;    
    ints=newintsj;
end

% if the for loop ran to completion (was not broken before j=0),
% set the scale of scaling coefficients now...
if isempty(coarsej)
    % RSW 6/05/2006: think this should be coarsej=j; why was
    % this not a problem before now?
    coarsej=j;
    %coarsej=j-1;
end

% fill in the scales and values for the scaling coefficients
% (filter coefficients remain as NaN vectors and predict neighbors as
% empty entries in the struct)...
tranvals(gridj)=vals(gridj);    % never predicted
scales(gridj)=coarsej;

% finally, assemble the matrix describing the overall transform, and
% compute its condition number....
tranmat=eye(numsens);

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
        Pj(predj(k),predneighbs{predj(k)})=predfilts{predj(k)};
        Uj(upneighbs{predj(k)},predj(k))=upfilts{predj(k)};
    end
    Iej=zeros(numsens,numsens); Ioj=zeros(numsens,numsens);
    for k=1:length(upj) Iej(upj(k),upj(k))=1; end
    for k=1:length(predj) Ioj(predj(k),predj(k))=1; end
    Ie{j}=Iej; Io{j}=Ioj;
    tranmatj=Iej+(eye(numsens)+Uj)*(Ioj-Pj);
    for k=j+1:1:startj
        tranmatj=tranmatj+Io{k};
    end
    tranmat=tranmatj*tranmat;
end

trancond=cond(tranmat);