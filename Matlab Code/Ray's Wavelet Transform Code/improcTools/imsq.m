function imsq(Im,tstr,xstr,ystr);

% usage:  function imsq(Im,tstr,xstr,ystr);
%
% Displays a square grayscale (256-level) image with
% title string, xlabel, ylabel
%
% input:    Im   - image to display
%           tstr - title string 
%           xstr - x-label string
%           ystr - y-lavel string
%
% return:   Imdsmp - downsampled iamge
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  6/25/03

figure; 
imagesc(Im);
colormap(gray(256));
axis square;

if nargin==2
    title(tstr);
elseif nargin==3
    title(tstr);
    xlabel(xstr);
elseif nargin==4
    title(tstr);
    xlabel(xstr);
    ylabel(ystr);
end

    