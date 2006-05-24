function roundnums=fix2(nums)

% usage:    roundnums=fix2(nums)
%
% given a scalar,vector, or matrix NUMS of 
% numbers, round then to have 2 decimal degits
% of precision
%
% input:    nums  -     scalar/matrix/vector 
%
% return:   roundnums - nums rounded to 2 decimal
%                       places
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  1/14/05

roundnums=(round(1e2*nums))/1e2;