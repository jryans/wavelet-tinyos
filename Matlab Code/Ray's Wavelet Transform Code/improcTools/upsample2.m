function [Imup]=upsample2(Im,fact);

% usage:  [Imup]=upsample2(Im,fact);
% 
% Upsamples an image by a specified factor 
% in each direction.
%
% input:    Im    - image to be upsampled
%           fact  - expansion factor
%           
% return:   Imup - upsampled image
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University, 
% Raytheon Missile Systems (unclassified)
% last rev: 7/03/03

Imup=zeros(fact*size(Im));

Imup(1:fact:size(Imup,1),1:fact:size(Imup,2))=Im;