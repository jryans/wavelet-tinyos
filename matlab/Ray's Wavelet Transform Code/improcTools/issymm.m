function [symm] = issymm(mat)

% usage:  [symm] = issymm(mat)
%
% returns 1 if matrix MAT is symmetric; 
% returns 0 otherwise
% 
% input:    mat     - matrix 
%           
% return:   symm    - flag indicating symmetry
%                     of mat
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev: 6/1/04

if sum(sum(triu(mat)-tril(mat)'))==0
    symm=1;
else
    symm=0;
end

