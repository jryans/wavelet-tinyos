function [scales,predneighbs,predfilts,upneighbs,upfilts] = dataExport(coords)
%DATAEXPORT Summary of this function goes here
%   Detailed explanation goes here
import edu.rice.compass.*
[scales,predneighbs,predfilts,upneighbs,upfilts]=moterCoeffs(coords);
% scale reversal
biggest = (max(scales) + 1);
scales = (scales - biggest) * -1;
zeroels = find(scales == biggest);
for i=1:length(zeroels)
    scales(zeroels(i)) = 0;
end
WaveletConfigExport(scales, predneighbs, predfilts, upfilts);