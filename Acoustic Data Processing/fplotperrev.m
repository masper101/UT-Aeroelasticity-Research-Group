function fplotperrev(RPM,bladenumber)

perrev = RPM/60;
perrevs = perrev*[bladenumber:bladenumber:bladenumber*200]';

YL = get(gca, 'YLim');

plot([perrevs,perrevs],YL,'k-','HandleVisibility','off')