function [scIm]=scalegray(Im,mn,mx)

% usage:  [scIm]=scalegray(Im,mn,mx)
%
% displays a vector with the minimum and
% maximum values in the image.
%
%
% input:    Im  - input [0,255] grayscale image
%           mn  - minimum [0,255] grayscale value for new image
%           mx  - maximum [0,255] grayscale value for new image
%           
% return:   scIm -  new image scaled to have minmum grayscale value
%                   mn, maximum grayscale value mx
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev: December 1, 2003.

% extract old minmum and maximum values....
oldmn=min(min(Im));
oldmx=max(max(Im));

% normalize range from [oldmn,oldmx] onto [0,1]....
tempIm=Im-oldmn;
tempIm=tempIm/(oldmx-oldmn);

% scale normalization by (mx-mn)....
tempIm=tempIm*(mx-mn);

% bias new scaled image by mn....
tempIm=tempIm+mn;

scIm=tempIm;
clear tempIm;
