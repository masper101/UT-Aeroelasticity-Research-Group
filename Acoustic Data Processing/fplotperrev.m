function fplotperrev(RPM,bladenumber)

perrev = RPM/60;
perrevs = perrev*[bladenumber:bladenumber:bladenumber*10]';

YL = get(gca, 'YLim');

plot([perrevs,perrevs],YL,'r--','HandleVisibility','off')