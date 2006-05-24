function [wavimg]=wav2dfor(img,wavtype)

% usage:     [wavimg]=wav2dfor(img,wavtype)
%
% return the 2-d wavelet decomposition in a recursive [LL,LH; HL; HH]
% array.  uses the MATLAB wavelet toolbox.
%
% input:        ing     -   2-d array to be transformed
%               wavtype -   wavelet filters to be used
%                           (type "help waveinfo" for 
%                            available filters)
% output:       wavimg  -   2-d coefficient array
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  9/12/05


% iterate to a single scaling coefficient, using
% periodized boundary treatment...

[ca,ch,cv,cd]=dwt2(img,wavtype,'mode','per'); 

if size(ca,1)==1
    wavimg=[ca,ch;cv,cd];
else 
    wavimg=[wav2dfor(ca,wavtype),ch; cv,cd];
end