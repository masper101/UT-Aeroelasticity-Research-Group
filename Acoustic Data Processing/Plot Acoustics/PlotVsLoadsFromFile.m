% PLOTS ACOUSTICS AND LOADS

clear; clc; close all;
addpath('/Users/chloe/Box/Chloe Lab Stuff/2020 Fall Stacked Rotor/Results');

load('acousticdata.mat')
load('testmatrix.mat');
load('zc0_loads.mat')
load('colors.mat')

%% GET DATA
avg = loads.AvgData; 
loads_names = strrep(avg.names','-','_');
loads_names = strrep(loads_names,'.csv','');
diffs = testmat.diff;
phis = testmat.phi; 
colls = testmat.coll;
rpms = testmat.rpm;

%%
phi_plot = [28.1250   39.3750   45.0000   50.6250   67.5000   90.0000];
c = {'+-','o-','*-','.-','x-','s-','d-','^-'};
cnt=0;
for phi_des = phi_plot
% INPUTS
rpm_des = 1200; 
% phi_des = 90; 
diff_des = 0; 

loc = contains(testmat.name, '201118') | contains(testmat.name, '201119');
loc = loc & (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);

% PLOT W PEAKS
clear oaspl oasplA cts tonal bb 
plot_ac = data(loc);
for i = 1:length(plot_ac)
    oaspl(i) = plot_ac{i}(3).oaspl;
    oasplA(i) = plot_ac{i}(3).oasplA;
    tonal(i) = plot_ac{i}(3).tonal;
    bb(i) = plot_ac{i}(3).bb;
    
    loc_loads = strcmp(plot_ac{i}(1).name, loads_names);
    cts(i) = avg.avg_cts_total(loc_loads);
end
[cts,b] = sort([cts{:}]);
oaspl = oaspl(b);
oasplA = oasplA(b);

figure(1)
hold on
cnt=cnt+1;
plot(cts, oaspl,c{cnt})

figure(2)
hold on
plot(cts, oasplA,c{cnt})

figure(3)
hold on
plot(cts, tonal,c{cnt})

figure(4)
hold on
plot(cts, bb,c{cnt})

end

figure(1)
xlabel('C_T/\sigma')
ylabel('OASPL, dB')
legend(num2str(phi_plot'),'location','NW')

figure(2)
xlabel('C_T/\sigma')
ylabel('OASPL_A, dB_A')
legend(num2str(phi_plot'),'location','NW')

figure(3)
xlabel('C_T/\sigma')
ylabel('Tonal Component, dB')
legend(num2str(phi_plot'),'location','NW')

figure(4)
xlabel('C_T/\sigma')
ylabel('Broadband Component, dB')
legend(num2str(phi_plot'),'location','NW')

