function [Imav]=blockav(Im,rowav,colav);

% usage:  [Imav]=blockav(Im,rowav,colav);
% 
% Blockwise-averages an image by summing over
% image blocks
%
% input:    Im    - image to be averaged
%           rowav - number of rows in averaging block
%           colav - number of columns in averaging block
%           
% return:   imav  - averaged image
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University, 
% Raytheon Missile Systems (unclassified)
% last rev: 9/01/03

if rem(size(Im,1),rowav)~=0
    error(['Unable to average over blocks with ' num2str(rowav) ' rows...']);
end

if rem(size(Im,2),colav)~=0
    error(['Unable to average over blocks with ' num2str(colav) ' columns...']);
end

Imav=zeros(size(Im,1)/rowav, size(Im,2)/colav);

for i=1:size(Imav,1)
    for j=1:size(Imav,2)
        rstrt=(i-1)*rowav+1;
        cstrt=(j-1)*colav+1;
        rstp=rstrt+rowav-1;
        cstp=cstrt+colav-1;
        Imav(i,j)=sum(sum(Im(rstrt:rstp,cstrt:cstp)))/(rowav*colav);
    end
end


        