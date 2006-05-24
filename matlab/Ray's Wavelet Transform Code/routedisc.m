function [hops]=routedisc(coords,commrad)

% usage:    [hops]=routedisc(coords,commrad)
%
% given a list COORDS of coordinates and a communication
% radius COMMRAD, return a NUMSENS (length of COORDS) x NUMSENS
% routing table HOPS detailing the shortest path (in hops)
% between all sensors...
% 
% input:        coords      -   list of node coordinates
%               commrad     -   maximum node communication radius
%              
% output:       hops        -   NUMSENSxNUMSENS routing table giving
%                               minimum hops between node pairs
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  10/27/05


numsens=size(coords,1);
hops=Inf*ones(numsens,numsens);
for i=1:numsens
    distsi=dist2(coords(i,:),coords);
    hops(i,find(distsi<=commrad))=1;
    hops(i,i)=0;
end

oldhops=hops;
done=0;

while ~done
	for i=1:numsens
        for j=1:numsens
            distsij=hops(i,:)+hops(:,j)';
            hops(i,j)=min([hops(i,j),distsij]);
        end
	end
    if sum(sum(hops==oldhops))==numsens^2
        done=1;
    else
        oldhops=hops;
    end
end

figure; hold on; plot(coords(:,1),coords(:,2),'b*'); 
for i=1:numsens 
    text(coords(i,1),coords(i,2)-0.05,num2str(i));
end
for i=1:numsens 
    distsi=dist2(coords(i,:),coords); 
    closepts=find(distsi<=commrad); 
    for j=1:length(closepts) 
        plot([coords(i,1),coords(closepts(j),1)],[coords(i,2),coords(closepts(j),2)],'b-'); 
    end 
end