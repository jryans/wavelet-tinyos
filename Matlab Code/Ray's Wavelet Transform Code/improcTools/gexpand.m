function [Imusmp]=gexpand(Im);

% usage:  [Imusmp]=gexpand(Im);
%
% Performs a one-level gaussian pyramid
% resolution expansion.  
%
% See A. Rosenfeld (Ed.), "Multiresolution
% Image Processing and Analysis," Springer-
% Verlag, Berlin/New York, 1984, pp. 10-13.
%
% input:    Im    - image to be upsampled
%
% return:   Imusmp - downsampled iamge
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

Imusmp=zeros(2*size(Im));
Imusmp(1:2:size(Imusmp,1),1:2:size(Imusmp,2))=Im;


% Periodically replicate image at edges to provide non-zero support across 
% kernal for convolution at edges
imsize=size(Imdsmp,1);
Imdsmp=[Imdsmp(imsize-overlap+1:imsize,:); Imdsmp ; Imdsmp(1:overlap,:)];
Imdsmp=[Imdsmp(:,imsize-overlap+1:imsize) , Imdsmp , Imdsmp(:,1:overlap)];     
Imdsmp=conv2(Imdsmp,w,'valid');
Imdsmp=Imdsmp(1:2:size(Imdsmp,1),1:2:size(Imdsmp,2));

% % mirror image at edges to provide non-zero support across 
% % kernal for convolution at edges
% imsize=size(Imusmp,1);
% Imusmp=[flipud(Imusmp(1:overlap,:)) ; Imusmp ; flipud(Imusmp(imsize-overlap+1:imsize,:))];
% Imusmp=[fliplr(Imusmp(:,1:overlap)) , Imusmp , fliplr(Imusmp(:,imsize-overlap+1:imsize))];     

Imusmp=4*conv2(Imusmp,w,'valid');