function [tranvals]=dwtmeshless(vals,trandata,type);

% usage:
% [tranvals]=dwtmeshless(vals,trandata,type);
%
% given wavelet lifting coefficients for a set of irregularly-spaced data 
% points, calculated according to trangen2d.m, compute the wavelet 
% transform coefficients for the spatial function values at those points.
% can either be computed using iterated lifting stages or directly using
% a single transform matrix multiplication.
% 
% input:        vals        -   values at irregular sample points
%               trandata    -   wavelet lifting transform coefficients
%                               from trangen2d.m (scales,predneighbs,
%                               predcoeffs,upneighbs,upcoeffs,W)
%
% (optional)    type        -   'lift' for computation with iterated
%                               lifting stages (default) or 'mult' 
%                               for transform matrix W multiply 
%
% output:       tranvals    -   wavelet transform coefficients
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  7/28/06

% numerically, inverting with W is a bit less stable than using
% iterated lifting, so the default is set to use lifting to match
% the default of the inverse transform.  note that the code should
% run faster in MATLAB using the multiplication transform.
if nargin==2
    type='lift';
end

numsens=length(vals);   % extract number of points

scales=trandata{1};
predneighbs=trandata{2};
predcoeffs=trandata{3};
upneighbs=trandata{4};
upcoeffs=trandata{5};
W=trandata{6};

switch type
    case 'lift'
        tranvals=vals;
        for j=max(scales):-1:(min(scales)+1)
            scj=find(scales==j);
            % predict
            for k=1:length(scj)
                nodek=scj(k);
                tranvals(nodek)=tranvals(nodek)-predcoeffs{nodek}*tranvals(predneighbs{nodek});
            end
            % update
            for k=1:numsens
                if ~isempty(upneighbs{j}{k})
                    tranvals(k)=tranvals(k)+upcoeffs{j}{k}*tranvals(upneighbs{j}{k});
                end
            end
        end
    case 'mult'
        tranvals=W*vals;
    otherwise
        error('unsupported transform method requested...');
end

