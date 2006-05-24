function twolines=linestack(str1,str2);

% usage:  twolines=linestack(str1,str2);
%
% form a two-line string object composed
% of two one-line string objects...
%
% input:    str1 - top-line string
%           str2 - bottom-line string
%
% return:   twolines - two-line string array
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  7/21/03

ln1=length(str1);
ln2=length(str2);

sps=abs(ln1-ln2);
splt=round(sps/2);
sprt=sps-splt;

padlt=[];
padrt=[];
for i=1:splt
    padlt=[padlt, ' '];
end
for i=1:sprt
    padrt=[padrt, ' '];
end

if ln1>ln2
    twolines=[str1;padlt,str2,padrt];
else
    twolines=[padlt,str1,padrt;str2];
end
    