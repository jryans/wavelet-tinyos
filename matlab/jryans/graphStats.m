function [transRes, names] = graphStats( subdir )

import edu.rice.compass.*;
results = StatsMatlab.loadStats(subdir);

names = results(:,1);
numRes = size(results,1);
transRes = zeros(numRes, 8);
for i=1:numRes
    tempName = names(i);
    len = size(tempName,2);
    transRes(i,1) = str2num(tempName(1:len-4));
    transRes(i,8) = results(i,2).get_pRcvd();
    transRes(i,2) = results(i,2).get_rssiMin() - 45;
    transRes(i,3) = results(i,2).get_rssiMax() - 45;
    transRes(i,5) = results(i,2).get_lqiMin();
    transRes(i,6) = results(i,2).get_lqiMax();
    if transRes(i,8) == 0
        transRes(i,7) = 0;
        transRes(i,4) = 0;
    else
        transRes(i,7) = results(i,2).get_lqiSum() / results(i,2).get_pRcvd();
        transRes(i,4) = (results(i,2).get_rssiSum() / results(i,2).get_pRcvd()) - 45;
    end
end