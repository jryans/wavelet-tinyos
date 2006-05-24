function [Imdec]=decimate2(Im,fact);

% usage:  function [Imdec]=decimate2(Im,fact);
% 
% Decimates an image by a specified factor 
% in each direction.
%
% input:    Im    - image to be downsampled
%           fact  - decimation factor
%           
% return:   Imdec - decimated image
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University, 
% Raytheon Missile Systems (unclassified)
% last rev: 7/02/03

Imdec=Im(1:fact:size(Im,1),1:fact:size(Im,2));