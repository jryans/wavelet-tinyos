function [threshdata]=coeffthresh_scalemod(thresh,trandata)

% usage:    [threshdata]=coeffthresh_scalemod(thresh,trandata)
%
% MODIFIED version of coeffthresh to allow for scale-dependent
% thresholding...
%
% given  a threshold and a struct containing wavelet transform data,
% set to zero all wavelet coeffecients in the struct whose
% magnitudes are below the threshold 
% 
% input:        thresh      -   threshold to apply to wavelet coefficient 
%                               magnutides
%               trandata    -   a struct containing for each level of the 
%                               transform a struct LEV* with transform values 
%                               and coefficients for that level, as well as
%                               scaling sensor ID's and values 
%
% output:      threshdata   -   struct containing thresholded data
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  5/02/05

% first, ensure that the threshold is a magnitude...
thresh=abs(thresh);

% initialize the return struct and copy all scaling
% information...
threshdata=struct([]);
numlevs=length(trandata)-1;
threshdata{numlevs+1}=trandata{numlevs+1};

% must reverse scale labels 
scalevec=[length(trandata)-1:-1:1];  

% now go through and alter the appropriate coefficients...
for k=1:numlevs
    levk=trandata{k};   % extract appropriate transform level
    coeffsk=levk{2};    % extract wavelet values
    coeffsk(abs(coeffsk)*2^(-scalevec(k))<thresh)=0;
    threshdata{k}{1}=levk{1};   % restore sensor list
    threshdata{k}{2}=coeffsk;   % insert thresholded wavelet values
    threshdata{k}{3}=levk{3};   % restore predict filter
    threshdata{k}{4}=levk{4};   % restore update filter    
end

    
