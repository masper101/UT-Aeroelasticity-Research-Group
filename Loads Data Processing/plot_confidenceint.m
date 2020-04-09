function plot_confidenceint(xdata, ydata, yerr, color)

plot(xdata,ydata,'color',color,'LineWidth',1.2)
hold on
fill([xdata, flip(xdata)],[ydata, flip(ydata)+yerr],color,'facealpha',.2,'LineStyle','none')
fill([xdata, flip(xdata)],[ydata, flip(ydata)-yerr],color,'facealpha',.2,'LineStyle','none')
