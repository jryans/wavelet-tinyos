function [raw, wt, rawhat, diff, avg] = compareMoteData(scales,predneighbs,predfilts,upneighbs,upfilts,varargin)

import edu.rice.compass.*;
if size(varargin, 2) >= 1
    values = WaveletMatlab.loadData(varargin(1));
else
    values = WaveletMatlab.loadData('waveletData.xml');
end
numSets = size(values, 1);
numSens = size(values, 2) / 2;
numMotes = size(values, 3);
diff = zeros(numSets, numSens);
raw = zeros(numSets, numSens, numMotes);
wt = zeros(numSets, numSens, numMotes);
rawhat = zeros(numSets, numSens, numMotes);
for j=1:numSets
    for h=1:numSens
        raw(j,h,:) = shiftdim(values(j,h*2 - 1,:), 1)';
        wtval = shiftdim(values(j,h*2,:), 1)';
        wt(j,h,:) = wtval;
        rawhat(j,h,:) = itrecon_meshless(wtval,scales,predneighbs,predfilts,upneighbs,upfilts);
        diff(j,h) = sum(abs((raw(j,h,:) / max(raw(j,h,:))) - (rawhat(j,h,:) / max(rawhat(j,h,:)))));
        avg(j,h) = mean(abs((raw(j,h,:) / max(raw(j,h,:))) - (rawhat(j,h,:) / max(rawhat(j,h,:)))));
    end
end