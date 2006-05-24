function [dists]=dist2(point,neighbs)

% usage:    [dists]=dist2(point,neighbs)
%
% given an ordered pair POINT and a list NEIGHBS
% of ordered pairs, find the euclidean (2-norm) 
% distance between POINT and each of the ordered 
% pairs in NEIGHBS
% 
% input:        point       -   a single ordered pair
%               nieghbs     -   a list of ordered pairs
%              
% output:       dists       -   euclidean distance from POINT
%                               to each of NEIGHBS
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/27/05


dists=sqrt((point(1,1)-neighbs(:,1)).^2+(point(1,2)-neighbs(:,2)).^2);