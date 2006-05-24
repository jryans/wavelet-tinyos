function IM=deraster(imvec,rws,cls)

% usage:  IM=deraster(imvec,rws,cls)
%
% Returns the 2-d reconstruction of an image
% vector resulting from the left-to-right, 
% top-to-bottom raster scan of that original 
% image (of size rws-by-cls).  
%
% Where a=[1 2 3 4]', 
% deraster(A) => [ 1  2
%                  3  4]
%
% input:    imvec - image scan to be de-rastered
%           rows  - rows in output image
%           cols  - columns in output iamge
%           
% return:   IM    - de-rastered image
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev: April 2, 2003.  

if length(imvec)~=rws*cls
    error('Cannot recontruct an image of the requested size');
end

temp=reshape(imvec,cls,rws);
IM=temp';