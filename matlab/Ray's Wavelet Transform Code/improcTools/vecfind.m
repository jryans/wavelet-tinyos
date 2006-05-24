function [invec]=vecfind(vec,elts)

% usage:    [invec]=vecfind(vec,elts)
%
% given a vector VEC and a vector ELTS of 
% candidate elements, return those elements 
% which actually appear in VEC
%
% input:    vec       - vector 
%           elts      - candidate elements 
%
% output:   invec     - elements in both VEC and ELTS
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  3/01/05

invec=[];
for i=1:length(elts)    
    indi=find(vec==elts(i));
    if ~isempty(indi)
        invec=[invec,vec(indi(1))];
    end
end
