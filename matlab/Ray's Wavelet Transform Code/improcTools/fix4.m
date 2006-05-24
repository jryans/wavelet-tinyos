function roundnums=fix4(nums)

% usage:    roundnums=fix4(nums)
%
% given a scalar,vector, or matrix NUMS of 
% numbers, round then to have 4 decimal degits
% of precision
%
% input:    nums  -     scalar/matrix/vector 
%
% return:   roundnums - nums rounded to 4 decimal
%                       places
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  9/06/04

roundnums=(round(1e4*nums))/1e4;
