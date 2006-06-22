function [rawfinal, wtfinal, diff] = compareMoteData(scales,predneighbs,predfilts,upneighbs,upfilts)

import edu.rice.compass.*;
wx = WaveletConfigExport();
values = wx.loadData();
numSets = size(values, 1);
numSens = size(values, 2) / 2;
numMotes = size(values, 3);
diff = zeros(numSets, numSens);
rawfinal = zeros(numSets, numSens, numMotes);
wtfinal = zeros(numSets, numSens, numMotes);
for j=1:numSets
    for h=1:numSens
        raw = shiftdim(values(j,h*2 - 1,:), 1)';
        wt = shiftdim(values(j,h*2,:), 1)';
        wthat=itrecon_meshless(wt,scales,predneighbs,predfilts,upneighbs,upfilts);
        rawfinal(j,h,:) = raw;
        wtfinal(j,h,:) = wthat;
        diff(j,h) = sum(abs(wthat - raw));
    end
end