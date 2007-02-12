function [td] = dataExport(coords)
import edu.rice.compass.*
[td]=trangen2d(coords);
% scale reversal
% scalesr = trandata{1};
% biggest = (max(scalesr) + 1);
% scalesr = (scalesr - biggest) * -1;
% zeroels = find(scalesr == biggest);
% for i=1:length(zeroels)
%     scalesr(zeroels(i)) = 0;
% end
WaveletMatlab.saveConfig(coords, td{1}, td{2}, td{3}, td{4}, td{5});