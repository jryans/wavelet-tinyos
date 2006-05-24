function [Imusmp]=gpyr_up(Im,fact);

% usage:  [Imusmp]=gpyr_up(Im,fact);
%
% Returns the gaussian pyramid image at a 
% given power-of-two resolution expansion 
% level.  
%
% See A. Rosenfeld (Ed.), "Multiresolution
% Image Processing and Analysis," Springer-
% Verlag, Berlin/New York, 1984, pp. 10-13.
%
% input:    Im    - image to be upsampled
%           fact  - log2(expansion factor)
%
% return:   Imusmp - upsampled image
%           (array of doubles in the set
%            {0,1,...,255} )
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University, 
% Raytheon Missile Systems (unclassified)
% last rev: 6/25/03

if (size(Im,1)~=size(Im,2) | rem(size(Im,1),2)~=0)
    error('Image must be square with power-of-two size');
end

Imusmp=Im;
count=0;

for i=1:fact
    Imusmp=gexpand(Imusmp);
    count=count+1;
end

Imusmp=floor(Imusmp);