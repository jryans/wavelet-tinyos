function [unsortvals]=unsort(sortvals,sortind);

% usage:    [unsortvals]=unsort(sortvals,sortind);
%
% given values VALS sorted according to an index SORTIND,
% undo the sorting described by SORTIND
%
% input:    sortvals    -   sorted values
%           sortind     -   sorting index
%
% return:
%           unsortvals  -   unsorted values
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  8/23/04

unsortvals=zeros(size(sortvals));

for i=1:length(sortvals)
    unsortvals(sortind(i))=sortvals(i);
end