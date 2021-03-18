%% PLOT ANY SPECTRA

load('colors.mat')

%% INPUTS
clear h 
phi_plot = [28.1250   39.3750   45.0000   50.6250   67.5000   90.0000];
phi_plot = [90 67.5 39.375];
for cnt = 1:length(phi_plot)
phi_des = phi_plot(cnt);
rpm_des = 1200;  
diff_des = 0; 
coll_des = 10;
c = colors{cnt};
markerstyle = {'v','o','*','.','x','s','d','^'};
m = markerstyle{cnt};

% loc = contains(testmat.name, '201118');
loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des) & (colls == coll_des);
% loc = contains(testmat.name, '201118')&contains(testmat.name, 'ref')&contains(testmat.name, 'b');
% PLOT W PEAKS
plotdata = {data{loc}};
for i = 1
    figure(5)
    semilogx(plotdata{i}(3).f, plotdata{i}(3).db,'color',c,'linewidth',0.7)
    hold on
    
    [a,b] = findpeaks(plotdata{i}(3).db,'Npeaks',12,'MinPeakDistance',35);
    h(cnt) = semilogx(plotdata{i}(3).f(b),a,m,'color',c,'markerfacecolor',c);
    hold on
end
end
%
xlim([20, 10^4])
ylim([0,80])
xlabel('Frequency, Hz')
ylabel('SPL, dB')
% grid on
set(gca,'fontsize',18)
l = legend(h,num2str(phi_plot'));
title(l,'\phi, deg')
