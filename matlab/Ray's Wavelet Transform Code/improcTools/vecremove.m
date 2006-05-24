function [newvec]=vecremove(vec,elts)

% usage:    [newvec]=vecremove(vec,elts)
%
% given a vector VEC and a vector ELTS of 
% elements to remove from VEC, return VEC
% with those elements removed
%
% input:    vec       - vector 
%           elts      - vector of elements to remove
%
% output:   newvec    - vec with those elements removed
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/21/04

for i=1:length(elts)
    indi=find(vec==elts(i));
    if isempty(indi)
        error(['element ' num2str(elts(i)) ' not in vector...']);
    end
    vec(indi)=NaN;
end

newvec=vec(~isnan(vec));

