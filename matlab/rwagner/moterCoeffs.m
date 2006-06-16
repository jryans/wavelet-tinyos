function [scales,predneighbs,predfilts,upneighbs,upfilts]=moterCoeffs(coords)

% usage:    [scales,predneighbs,predfilts,upneighbs,upfilts]=motercoeffs(coords)
%
% compute and display predict/update coefficients
% for the irregular-grid wavelet transform 
% itlift_meshless.m
% 
% input:        coords  -   NUMSEMSx2 array of node
%                           (x,y) coordinate locations                            
%
% output:       (none)
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  4/17/06

if max(max(coords))>1
    coordsOrig=coords;
    coords=coordsOrig/ceil(max(max(coordsOrig)));
    disp('re-normalizing coordinates to lie in unit box...');
    fprintf \n;
end

vals=zeros(size(coords,1),1);
[tranvals,scales,predneighbs,predfilts,upneighbs,upfilts,tranmat]=itlift_meshless(coords,vals);
numsens=size(coords,1);

for j=max(scales):-1:1
    disp('*******'); disp(['Scale ' num2str(j)]); disp('*******');
    fprintf \n; disp('PREDICT');
    predj=find(scales==j);
    upj=zeros(1,numsens);
    uneighbj=struct([]); ufiltj=struct([]);
    for k=1:numsens
        uneighbj{k}=[];
        ufiltj{k}=[];
    end
    for k=1:length(predj)
        nodek=predj(k);       
        pneighbsk=predneighbs{nodek};
        upneighbsk=upneighbs{nodek};     
        fprintf \t; disp(['node ' num2str(nodek)]);
        fprintf \t; fprintf \t;   
        disp(['neighbors : ' num2str(pneighbsk)]);
        fprintf \t; fprintf \t;   
        disp(['coefficients : ' num2str(predfilts{nodek})]);
        upj(upneighbsk)=1;
        for m=1:length(upneighbsk)
            uneighbj{upneighbsk(m)}=[uneighbj{upneighbsk(m)},nodek];
            ufiltj{upneighbsk(m)}=[ufiltj{upneighbsk(m)},upfilts{nodek}(m)];
        end
    end
    fprintf \n; disp('UPDATE');
    upj=find(upj==1);
    for k=1:length(upj)
        nodek=upj(k);
        fprintf \t; disp(['node ' num2str(nodek)]);
        fprintf \t; fprintf \t;   
        disp(['neighbors : ' num2str(uneighbj{nodek})]);
        fprintf \t; fprintf \t;   
        disp(['coefficients : ' num2str(ufiltj{nodek})]);
    end
end

