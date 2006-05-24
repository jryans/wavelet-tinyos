function [Imdsmp]=greduce(Im);

% usage:  [Imdsmp]=greduce(Im);
%
% Performs a one-level gaussian pyramid
% resolution reduction.  
%
% See A. Rosenfeld (Ed.), "Multiresolution
% Image Processing and Analysis," Springer-
% Verlag, Berlin/New York, 1984, pp. 10-13.
%
% input:    Im    - image to be downsampled
%
% return:   Imdsmp - downsampled iamge
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University, 
% Raytheon Missile Systems (unclassified)
% last rev: 8/19/03

% set width of gaussian kernal 
width=5;
overlap=ceil((width-1)/2);  % filter overlap at edge

% specify kernal
a = 0.4;    % mask constant - use 0.4 to approx gaussian
w=[0.25-a/2 , 0.25 , a , 0.25 , 0.25-a/2];
w=w'*w;

Imdsmp=Im;

% Periodically replicate image at edges to provide non-zero support across 
% kernal for convolution at edges
imsize=size(Imdsmp,1);
Imdsmp=[Imdsmp(imsize-overlap+1:imsize,:); Imdsmp ; Imdsmp(1:overlap,:)];
Imdsmp=[Imdsmp(:,imsize-overlap+1:imsize) , Imdsmp , Imdsmp(:,1:overlap)];    

% % mirror image at edges to provide non-zero support across 
% % kernal for convolution at edges
% imsize=size(Imdsmp,1);
% Imdsmp=[flipud(Imdsmp(1:overlap,:)) ; Imdsmp ; flipud(Imdsmp(imsize-overlap+1:imsize,:))];
% Imdsmp=[fliplr(Imdsmp(:,1:overlap)) , Imdsmp , fliplr(Imdsmp(:,imsize-overlap+1:imsize))]; 

Imdsmp=conv2(Imdsmp,w,'valid');

Imdsmp=decimate2(Imdsmp,2);   
