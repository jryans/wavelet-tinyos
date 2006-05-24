function [ahndl, thndl, xhndl, yhndl] = errshow2d(orig_h,orig_v,est_h,est_v,est_name);

% usage:  [ahndl, thndl, xhndl, yhndl] = errshow2d(orig_h,orig_v,est_h,est_v,est_name);
%
% Displays a plot connecting a set of points
% specified by horizontal and vertical coordinates 
% to a set of estimates specified similarly.  
% Estimates are connected with originals by lines.
%
% input:    orig_h -  horizontal truth
%           orig_v -  vertical truth
%           est_h  -  horizontal estimates
%           est_v  -  vertical estimates
%           est_name - string for name of estimate
%           
% return:   ahndl - handle to axes
%           thndl - handle to title string
%           xhndl - handle to x-axis label
%           yhndl - handle to y-axis label
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  1/13/04

figure; 
ahndl=axes;
plot(orig_h,orig_v,'bo');
hold on;
plot(est_h,est_v,'r*');
quiver(orig_h,orig_v,est_h-orig_h,est_v-orig_v,0,'.','k');
xhndl=xlabel('horizontal error (units of HR pixels)');
yhndl=ylabel('vertical error (units of HR pixels)');
thndl = title(['Error in estimation of ' est_name ' (o - original, * - estimation)']);
