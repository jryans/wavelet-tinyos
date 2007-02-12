function [vals]=idwtmeshless(tranvals,trandata,type);

% usage:
% [vals]=idwtmeshless(tranvals,trandata,type);
%
% given a set of wavelet transform coefficients and a set of 
% wavelet lifting coefficients for an irregularly-spaced set of
% sample points, calculated according to trangen2d.m, compute the 
% inverse wavelet transform to yield the original spatial function 
% values at those points.  can either be computed using iterated 
% lifting stages or directly using a single transform matrix 
% multiplication.
% 
% input:        tranvals    -   wavelet transform coefficients
%               trandata    -   wavelet lifting transform coefficients
%                               from trangen2d.m (scales,predneighbs,
%                               predcoeffs,upneighbs,upcoeffs,W)
%
% (optional)    type        -   'lift' for computation with iterated
%                               lifting stages or 'mult' for transform
%                               matrix W multiply (default)
%
% output:       vals        -   original values at irregular sample points 
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  7/28/06

% for inverse transform, set the default to iterated lifting,
% as cond(W) bigger than 1 in general, and inv(W) gives
% a bit more error in the reconstruction than the default.
% note that the code should run faster in MATLAB using the 
% multiplication transform.
if nargin==2
    type='lift';
end

numsens=length(tranvals);   % extract number of points

scales=trandata{1};
predneighbs=trandata{2};
predcoeffs=trandata{3};
upneighbs=trandata{4};
upcoeffs=trandata{5};
W=trandata{6};

switch type
    case 'lift'
        vals=tranvals;
        for j=(min(scales)+1):1:max(scales)
            % undo update
            for k=1:numsens
                if ~isempty(upneighbs{j}{k})
                    vals(k)=vals(k)-upcoeffs{j}{k}*vals(upneighbs{j}{k});
                end
            end
            scj=find(scales==j);
            % undo predict
            for k=1:length(scj)
                nodek=scj(k);
                vals(nodek)=vals(nodek)+predcoeffs{nodek}*vals(predneighbs{nodek});
            end

        end
    case 'mult'
        vals=inv(W)*tranvals;
    otherwise
        error('unsupported transform method requested...');
end