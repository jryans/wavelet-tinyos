function graphStats( subdir, totalpacks, type, perline, fixedval )

import edu.rice.compass.*;
results = StatsMatlab.loadStats(subdir);

% Determine type
switch type
  case 'dist'
    dpcol = 3;
    xname = 'Distance from Sink (m)';
  otherwise
    return;
end

switch perline
  case 'pl'
    gpcol = 2;
    fixedcol = 1;
    linepre = 'Power Level ';
    setpre = 'Channel ';
  case 'chan'
    gpcol = 1;
    fixedcol = 2;
    linepre = 'Channel ';
    setpre = 'Power Level ';
end

blksize = [1.22 1.09 0.61];
i = 0;
for j=1:size(results,1)
  res = results(j);
  name = res(1);
  slash = find(name == '/');
  if strcmp(type, 'dist')
    tid(1) = str2double(name(slash(1)+5:slash(2)-1));
    tid(2) = str2double(name(slash(2)+1:size(name,2)-4));
    distname = name(1:slash(1)-1);
    bpos = find(name == 'b');
    mpos = find(name == 'm');
    spos = find(name == 's');
    blks = [str2double(distname(1:bpos-1));
            str2double(distname(bpos+1:mpos-1));
            str2double(distname(mpos+1:spos-1))];
    tid(3) = blksize * blks;
  else
    tid(1) = str2double(name(5:slash-1));
    tid(2) = str2double(name(slash+1:size(name,2)-4));
  end
  if tid(fixedcol) == fixedval
    i = i + 1;
    id(i,:) = tid;    
  else
    continue;
  end
  transRes(i,1) = res(2).get_pRcvd() / totalpacks * 100;
  transRes(i,2) = res(2).get_rssiMin() - 45;
  transRes(i,3) = res(2).get_rssiMax() - 45;
  transRes(i,4) = res(2).get_rssiMean() - 45;
  transRes(i,5) = res(2).get_rssiMedian() - 45;
  transRes(i,6) = res(2).get_lqiMin();
  transRes(i,7) = res(2).get_lqiMax();
  transRes(i,8) = res(2).get_lqiMean();
  transRes(i,9) = res(2).get_lqiMedian();
  if res(2).get_pRcvd() < 5
    transRes(i,5) = transRes(i,4);
    transRes(i,9) = transRes(i,8);
  end
end

% Remove no packet data sets
baddata = ~excludedata(transRes(:,1),transRes(:,1),'range',[0 0]);
id(baddata, :) = [];
transRes(baddata, :) = [];

% Packets Received
p = makeplot(id,dpcol,gpcol,transRes(:,1),linepre);
xlabel(xname);
ylabel('Packets Received (%)');
title({['Packets Received vs. ', xname],[setpre,num2str(fixedval)]});
cleanup();
% Remove ticks above 100
yt = get(gca, 'YTick');
overmax = find(yt > 100);
if size(overmax,2) > 0
  set(gca, 'YTick', yt(1:overmax(1)-1));
end
set(p,'FileName','packs.fig');
hgsave(p,'packs.fig');
set(p,'Visible','on');

% LQI
p = makeplot(id,dpcol,gpcol,transRes(:,9),linepre);
xlabel(xname);
ylabel('Link Quality Indicator');
title({['Link Quality Indicator vs. ', xname],[setpre,num2str(fixedval)]});
%up = transRes(:,7) - transRes(:,9);
%down = transRes(:,9) - transRes(:,6);
%errorbar(transRes(:,9),transRes(:,9), down, up, 'b.');
cleanup();
set(p,'FileName','lqi.fig');
hgsave(p,'lqi.fig');
set(p,'Visible','on');

% RSSI
p = makeplot(id,dpcol,gpcol,transRes(:,5),linepre);
xlabel(xname);
ylabel('Received Signal Strength (dBm)');
title({['Received Signal Strength vs. ', xname],[setpre,num2str(fixedval)]});
%up = transRes(:,3) - transRes(:,5);
%down = transRes(:,5) - transRes(:,2);
%errorbar(transRes(:,5),transRes(:,5), down, up, 'b.');
cleanup();
set(p,'FileName','rssi.fig');
hgsave(p,'rssi.fig');
set(p,'Visible','on');

function p = makeplot( id, dpcol, graphcol, ydata, linepre )

p = figure('Visible','off');
%p = figure;
axes;
hold on;
co = get(gca,'ColorOrder');
opts = fitoptions('Method','NonlinearLeastSquares','Robust','LAR','Algorithm','Trust-Region','Display','off');
idu = unique(id(:,graphcol));
for i=1:size(idu, 1)
  gid = idu(i);
  %subplot(size(idu,1),1,i);
  gxdata = id(id(:,graphcol) == gid, dpcol);
  gydata = ydata(id(:,graphcol) == gid);
%   [fitres{1,1},fitres{1,2}] = fit(gxdata,gydata,'power1',opts);
%   [fitres{2,1},fitres{2,2}] = fit(gxdata,gydata,'power2',opts);
%   [fitres{3,1},fitres{3,2}] = fit(gxdata,gydata,'exp1',opts);
%   [fitres{4,1},fitres{4,2}] = fit(gxdata,gydata,'exp2',opts);
%   %[fitres{5,1},fitres{5,2}] = fit(cxdata,cydata,'poly1');
%   adjrs = 0;
%   goodfit = 0;
%   for j=1:4
%     if fitres{j,2}.adjrsquare > adjrs
%       adjrs = fitres{j,2}.adjrsquare;
%       goodfit = j;
%     end
%   end
%   if goodfit > 0
%     %line = plot(fitres{goodfit,1},'-');
%     %set(line,'DisplayName',[linepre,num2str(gid),' fit']);
%     %set(line,'Color',co(i,:));
%     %set(line,'LineWidth',1);
%   end
  line = plot(gxdata,gydata,'.','DisplayName',[linepre,num2str(gid)]);
  set(line,'Color',co(i,:));
  set(line,'MarkerSize',10);
end

function cleanup()

axis tight;
set(gca,'YLimMode','auto');
xl = get(gca,'XLim');
xl(1) = xl(1) - .01;
xl(2) = xl(2) + .01;
set(gca,'XLim',xl);
leg = legend('show');
set(leg,'FontName','AvantGarde','FontSize',6);
%legend('off');

