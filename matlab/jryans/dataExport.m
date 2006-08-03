function [scales,predneighbs,predfilts,upneighbs,upfilts] = dataExport(coords)
%DATAEXPORT Summary of this function goes here
%   Detailed explanation goes here
import edu.rice.compass.*
[scales,predneighbs,predfilts,upneighbs,upfilts]=moterCoeffs(coords);
% scale reversal
scalesr = scales;
biggest = (max(scalesr) + 1);
scalesr = (scalesr - biggest) * -1;
zeroels = find(scalesr == biggest);
for i=1:length(zeroels)
    scalesr(zeroels(i)) = 0;
end
WaveletMatlab.saveConfig(scalesr, predneighbs, predfilts, upfilts);