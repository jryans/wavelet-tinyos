function []=mnmx(Im)

% usage:  []=mnmx(Im)
%
% displays a vector with the minimum and
% maximum values in the image.
%
% input:    Im  - input image
%           
% return:   mn  - minimum value of image
%           mx  - maximum value of image
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev: October 4, 2003.  

mn=min(min(Im));
mx=max(max(Im));

fprintf('\n');
disp([mn,mx]);