function []=drawcirc(cent,rad,linstyle);

% usage:  function []=drawcirc(cent,rad,linstyle);
% 
% draws plots a circle given a center and radius....
%
% input:    cent    -   (x,y) coordinates of center
%           rad     -   radius of circule      
%       
%           OPTIONAL:
%           linstyle -  plot line style
%       
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University, 
% last rev: 9/02/04

if nargin==2
    linstyle='b-';
end

hold on;
lastpt=[cent(1)+rad,cent(2)];
for ang=1:360
    nextpt=[cent(1)+rad*cos(ang*pi/180),cent(2)+rad*sin(ang*pi/180)];
    plot([nextpt(1),lastpt(1)],[nextpt(2),lastpt(2)],linstyle);
    lastpt=nextpt;
end
    