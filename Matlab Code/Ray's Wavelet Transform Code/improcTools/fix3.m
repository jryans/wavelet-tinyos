function roundnums=fix3(nums)

% usage:    roundnums=fix3(nums)
%
% given a scalar,vector, or matrix NUMS of 
% numbers, round then to have 3 decimal degits
% of precision
%
% input:    nums  -     scalar/matrix/vector 
%
% return:   roundnums - nums rounded to 3 decimal
%                       places
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  9/06/04

roundnums=(round(1e3*nums))/1e3;
