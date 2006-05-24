function []=pubformat(fighndl)

% usage:     []=pubformat(fighndl)
%
% given a handle HNDL to a 2-d plot, format the text labels and line
% widths of the plot to be easily read in publications
%
% input:        fighndl    -   handle to a figure 
%                           (ex: figure(N) for the N'th figure window,
%                            gcf for current figure)
%
% output:       (none)
%
% Raymond S. Wagner (rwagner@rice.edu)
% Rice University
% last rev:  5/27/05

% specify line width:
lwidth=5;
% specify font size:
fntsz=20;

% get handle axes:
axhndl=get(fighndl,'CurrentAxes');
% get lines handle
lnhndl=get(axhndl,'Children');
% get label handles:
xlbhndl=get(axhndl,'XLabel');
ylbhndl=get(axhndl,'YLabel');
thndl=get(axhndl,'Title');
leghndl=legend(axhndl);

% set line width:
for i=1:length(lnhndl)
    set(lnhndl(i),'LineWidth',lwidth);
end

% set text size:
set(axhndl,'FontSize',fntsz);   % axis
set(xlbhndl,'FontSize',fntsz);   % x label
set(ylbhndl,'FontSize',fntsz);   % y label
set(thndl,'FontSize',fntsz);     % title
set(leghndl,'FontSize',fntsz);   % legend   