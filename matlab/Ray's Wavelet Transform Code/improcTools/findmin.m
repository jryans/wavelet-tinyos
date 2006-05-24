function [minrow,mincol]=findmin(mat)

% usage:    [minrow,mincol]=findmin(mat)
%
% given a 2-dimensional matrix MAT, 
% return the row and column indices of 
% the minimum element.  
%
% input:    mat       - 2-dimensional matrix
%
% output:   minrow    - row index of minimum element
%           mincol    - column index of minimum element
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/21/04

minelts=find(mat==min(min(mat)));
matrows=size(mat,1);
matcols=size(mat,2);
minrow=zeros(1,length(minelts));
mincol=zeros(1,length(minelts));
for i=1:length(minelts)
    minrow(1,i)=rem(minelts(i),matrows);
    if minrow(1,i)==0
        minrow(1,i)=matrows;
    end
    mincol(1,i)=ceil(minelts(i)/matrows);
end