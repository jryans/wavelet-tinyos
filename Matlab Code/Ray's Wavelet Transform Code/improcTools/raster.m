function imvec=raster(IM)

% usage:  imvec=raster(IM)
% 
% Returns the left-to-right, top-to-bottom raster 
% scan of a 2-d image.  Where   A=[ 1  2
%                                   3  4]
% raster(A) => [1 2 3 4]'
%
% input:    IM    - image to de-raster
%           
% return:   imvec - raster-scanned image vector
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev: April 2, 2003. 

temp=IM';
imvec=temp(:);