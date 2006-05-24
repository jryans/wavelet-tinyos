function [Imdsmp]=downsamp(Im,hfact,vfact);

% usage: [Imdsmp]=downsamp(Im,hfact,vfact);  
%  
% Downsamples an image by specified factors in
% the horizontal and vertical directions by
% averaging over blocks of the image.
%
% input:    Im    - image to be downsampled
%           hfact - horizontal compression factor
%           vfact - vertical compression factor
%           
% return:   Imdsmp - downsampled iamge
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University, 
% Raytheon Missle Systems (unclassified)
% last rev: 6/23/03

hsize=size(Im,2);
vsize=size(Im,1);

Imdsmp=zeros(vsize/vfact,hsize/hfact);

for y=1:size(Imdsmp,1)
    for x=1:size(Imdsmp,2)
        ystart=(y-1)*vfact+1;
        xstart=(x-1)*hfact+1;  
        ystop=ystart+vfact-1;
        xstop=xstart+hfact-1;
        block=Im(ystart:ystop,xstart:xstop);
        if (size(block,1)*size(block,2)~=hfact*vfact)
            error('Averaging blocks not the right size');
        end
        Imdsmp(y,x)=sum(sum(block))/(hfact*vfact);
        %Imdsmp(y,x)=block(1,1);
    end
end
        