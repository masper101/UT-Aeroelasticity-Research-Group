% PLOT SPECTRA FROM FILE

clear; clc; close all;
addpath('/Users/chloe/Box/Chloe Lab Stuff/2020 Fall Stacked Rotor/Results');

load('acousticdata.mat')
load('testmatrix.mat');
load('colors.mat')

%% GET DATA
diffs = testmat.diff;
phis = testmat.phi; 
colls = testmat.coll;
rpms = testmat.rpm;

%% PLOT REFERENCE

figure(1)
loc = contains(testmat.name, 'ref');
plotdata = {data{loc}};
for i = 1:length(plotdata)
    semilogx(plotdata{i}(3).f, plotdata{i}(3).db )%+ 10*(i-1))
    hold on
end
xlim([10^1, 10^4])
xlabel('Freq, Hz')
ylabel('SPL, dB')
grid on

%% PLOT ISOLATED ROTOR
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 2; 
diff_des = 0; 
coll_des = 8;
date_des = '201118';

figure(1)
loc = contains(testmat.name, '201118');
loc = loc & (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des) & (colls == coll_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    semilogx(plotdata{i}(3).f, plotdata{i}(3).db + 10*(i-1))
    hold on
end
hold on
fplotperrev(1200,2)
xlim([10^1, 10^4])
xlabel('Freq, Hz')
ylabel('SPL, dB')
grid on

%% PLOT SINGLE ROTOR

% --------------------1200 201118--------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 90; 
diff_des = 0; 
coll_des = 12;
date_des = '201118';

loc = contains(testmat.name, '201118');
loc = loc & (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des) & (colls == coll_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    figure(5)
    semilogx(plotdata{i}(3).f, plotdata{i}(3).db)
    figure(6)
    semilogx(plotdata{i}(3).f, plotdata{i}(3).dbA)
end
figure(5)
hold on
% fplotperrev(1200,4)
xlim([10^1, 10^4])
ylim([0,80])
xlabel('Frequency, Hz')
ylabel('SPL, dB')
grid on
set(gca,'fontsize',16)

figure(6)
hold on
% fplotperrev(1200,4)
xlim([10^1, 10^4])
ylim([-20,80])
xlabel('Frequency, Hz')
ylabel('SPLA, dB')
grid on
set(gca,'fontsize',16)


%% PLOT PHIS 
rpm_des = 1200; 
coll_des = 10; 
diff_des = 0; 

loc = (contains(testmat.name, '201118'))|(contains(testmat.name, '201119'));
loc = (phis ~= 2) & loc & (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (colls == coll_des) & (diffs == diff_des);
plotdata = {data{loc}};

count = 1;
for i = 1:length(plotdata)
% for i = [1:2]
    figure(2)
    semilogx(plotdata{i}(3).f, plotdata{i}(3).db + 40*(count-1))
    hold on
    
    figure(3)
    semilogx(plotdata{i}(3).f, plotdata{i}(3).dbA + 40*(i-1))
    hold on
    count = count + 1;
end

figure(2)
fplotperrev(1200,2)
xlim([10^1, 10^4])
xlabel('Freq, Hz')
ylabel('SPL, dB')
grid on
leg = phis(loc);
l = legend(num2str(leg([1:6],1)),'location','eastoutside');
title(l,'\phi')

figure(3)
fplotperrev(1200,2)
xlim([10^1, 10^4])
xlabel('Freq, Hz')
ylabel('SPLA, dB')
grid on
l = legend(num2str(phis(loc)),'location','eastoutside');
title(l,'\phi')



