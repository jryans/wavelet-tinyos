function [xcomp]=complement(mat,x)

% usage:    [xcomp]=complement(mat,x)
%
% given a matrix MAT and a vector of elements X,
% return XCOMP, a vector of the complement of X in 
% MAT
%
% input:    mat       - matrix
%           x         - vector of elements in mat
%
% output:   xcomp     - complement of x in mat
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  5/12/04

mvec=mat(:)';
compind=ones(size(mvec));

if isempty(x)
    xcomp=mvec;
else
	for i=1:length(x)
        compind=compind & mvec~=x(i);
	end
	xcomp=mat(compind);
end
