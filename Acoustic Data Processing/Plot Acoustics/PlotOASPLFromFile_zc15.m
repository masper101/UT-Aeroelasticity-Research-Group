% PLOT OASPL FROM FILE
clear; clc; close all;
addpath('/Users/chloe/Box/Chloe Lab Stuff/2021 Spring Stacked Rotor/Results/zc15');

load('zc15_ac.mat')
load('zc15_ac_testmat.mat');
load('colors.mat')

%% GET DATA
diffs = testmat.diff;
phis = testmat.phi; 
colls = testmat.coll;
rpms = testmat.rpm;

%% PLOT REFERENCE
loc = contains(testmat.name, 'ref');
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(10)
l = plot(oaspl,'o');
l.MarkerFaceColor = l.Color;
grid on
xlabel('Reference Number')
ylabel('OASPL, dB')
yl = ylim;


%% PLOT ISOLATED ROTOR
% --------------------1200--------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 2; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(1)
hold on
l = plot(colls(loc),oaspl,'o');
l.MarkerFaceColor = l.Color;
legend('990 RPM','1200 RPM','location','northwest')


%% PLOT PHIS
% -------------------- -90 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 90; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;
grid on
xlabel('Collective')
ylabel('OASPL, dB')

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
grid on
xlabel('Collective')
ylabel('OASPLA, dB')
% -------------------- -45 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = -45; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
% -------------------- -16.875 --------------------
clear oaspl oasplA tl bb
rpm_des = 1200; 
phi_des = -16.875; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
    tl(i,1) = plotdata{i}(3).dBtl;
    bb(i,1) = plotdata{i}(3).dBbb;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
    hold on
    [a,b] = sort(colls(loc));
    l = plot(a,oasplA(b),'o');
    l.MarkerFaceColor = l.Color;
figure(7)
    hold on
    [a,b] = sort(colls(loc));
    l = plot(a,tl(b),'o');
    l.MarkerFaceColor = l.Color;
figure(8)
    hold on
    [a,b] = sort(colls(loc));
    l = plot(a,bb(b),'o');
    l.MarkerFaceColor = l.Color;
% -------------------- -11.25 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = -11.25; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
% -------------------- -5.625 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = -5.625; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
% --------------------0--------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 0; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;
% -------------------- 5.625 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 5.625; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
% -------------------- 11.25 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 11.25; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
% -------------------- 16.875 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 16.875; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
% -------------------- 45 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 45; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
% -------------------- 90 --------------------
clear oaspl oasplA
rpm_des = 1200; 
phi_des = 90; 
diff_des = 0; 

loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;

figure(6)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oasplA(b),'o');
l.MarkerFaceColor = l.Color;
%----------------
l = legend('-90','-45', '-16.875','-11.25','-5.625','0','5.625','11.25','16.875','45','90','location','northwest');
title(l,'\phi')

figure(4)
l = legend('-90','-45', '-16.875','-11.25','-5.625','0','5.625','11.25','16.875','45','90','location','northwest');
title(l,'\phi')

%% PLOT VS PHI
clear oaspl oasplA bb tl phi_uni oaspls oasplAs tls bbs
rpm_des = 1200; 
coll_des = 10; 
diff_des = 0; 

loc = (phis ~= 2)& (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (colls == coll_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
    oaspl(i,1) = plotdata{i}(3).oaspl;
    oasplA(i,1) = plotdata{i}(3).oasplA;
    bb(i,1) = plotdata{i}(3).dBbb;
    tl(i,1) = plotdata{i}(3).dBtl;
end

phi_plot = phis(loc);
phi_uni = unique(phi_plot);
for i = 1:length(phi_uni)
    loc = phi_plot==phi_uni(i);
    oaspls(i,1) = mean(oaspl(loc));
    oasplAs(i,1) =mean(oasplA(loc));
    bbs(i,1) = mean(bb(loc));
    tls(i,1) = mean(tl(loc));
end

loc_90 = phi_uni==90;
phi_uni =[phi_uni; -1*phi_uni(loc_90)];
oaspls = [oaspls; oaspls(loc_90)];
oasplAs = [oasplAs; oasplAs(loc_90)];
bbs = [bbs; bbs(loc_90)];
tls = [tls; tls(loc_90)];

figure(7)
hold on
[a,b] = sort(phi_uni);
l = plot(a,oaspls(b),'ko-');
l.MarkerFaceColor = l.Color;
xlabel('Azimuthal Spacing, \phi')
ylabel('OASPL, db')

figure(8)
hold on
[a,b] = sort(phi_uni);
l = plot(a,oasplAs(b),'ko-');
l.MarkerFaceColor = l.Color;
xlabel('Azimuthal Spacing, \phi')
ylabel('OASPLA, db')

figure(7)
hold on
[a,b] = sort(phi_uni);
l = plot(a,bbs(b),'o-');
l.MarkerFaceColor = l.Color;
xlabel('Azimuthal Spacing, \phi')
ylabel('Broadband Noise, dB')

figure(7)
hold on
[a,b] = sort(phi_uni);
l = plot(a,tls(b),'ko-');
l.MarkerFaceColor = l.Color;
xlabel('Azimuthal Spacing, \phi')
ylabel('Tonal + Loading Noise, dB')


%% any
clear oaspl oasplA
rpm_des = 990;
phi_des = -11.25;
diff_des = 0;
loc = (rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
oaspl(i,1) = plotdata{i}(3).oaspl;
oasplA(i,1) = plotdata{i}(3).oasplA;
end
figure(4)
hold on
[a,b] = sort(colls(loc));
l = plot(a,oaspl(b),'o');
l.MarkerFaceColor = l.Color;
