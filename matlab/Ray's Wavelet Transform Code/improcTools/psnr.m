function [psnr] = psnr(Estimate,Org)

% usage:  [psnr] = psnr(Estimate,Org)
%
% gives psnr in db
% calculates it as 20*log10(M*255/rmse);
% 
% input:    Estimate - estimate array
%           Original - truth array
%           
% return:   psnr - peak signal-to-noise ratio
%
% Neelsh 
% Rice University
% last rev: 1/1/03

M = length(Org(:));
mse = (norm(Org(:)-Estimate(:)))^2;
psnr = 10*log10(M*255*255/mse);

