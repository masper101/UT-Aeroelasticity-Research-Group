function plot_confidenceint(xdata, ydata, yerr, color)

plot(xdata,ydata,'color',color,'LineWidth',1.2);
hold on
p1 = fill([xdata, flip(xdata)],[ydata, flip(ydata)+yerr],color,'facealpha',.2,'LineStyle','none');
p2 = fill([xdata, flip(xdata)],[ydata, flip(ydata)-yerr],color,'facealpha',.2,'LineStyle','none');
p1.HandleVisibility = 'off';
p2.HandleVisibility = 'off';
