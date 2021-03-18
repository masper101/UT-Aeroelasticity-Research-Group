%% PLOT BB/TONAL FROM FILE

%% GET DATA
diffs = testmat.diff;
phis = testmat.phi; 
colls = testmat.coll;
rpms = testmat.rpm;

%% ISOLATED
clear tonal bb
rpm_des = 1200; 
phi_des = 2; 
diff_des = 0; 

loc = contains(testmat.name, '201118');
loc = loc&(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
end
figure(1)
hold on
l = plot(colls(loc),tonal,'o');
hold on
l2 = plot(colls(loc),bb,'o');
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;

legend('Tonal','Broadband','location','NW')
grid on
ylabel('OASPL, dB')
set(gca,'fontsize',16)
xlabel('Collective, deg')

%% 4-BLADED
clear tonal bb
rpm_des = 1200; 
phi_des = 90; 
diff_des = 0; 

loc = contains(testmat.name, '201118');
loc = loc&(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
end
figure(2)
hold on
l = plot(colls(loc),tonal,'o');
hold on
l2 = plot(colls(loc),bb,'o');
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;

legend('Tonal','Broadband','location','NW')
grid on
ylabel('OASPL, dB')
set(gca,'fontsize',16)
xlabel('Collective, deg')

%% PHIS
% --------------------28.125--------------------
clear tonal bb
rpm_des = 1200; 
phi_des = 28.125; 
diff_des = 0; 

loc = contains(testmat.name, '201118')|(contains(testmat.name, '201119'));
loc = loc&(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
end
figure(5)
subplot(2,1,1)
hold on
l = plot(colls(loc),tonal,'o','color',colors{1});
subplot(2,1,2)
hold on
l2 = plot(colls(loc),bb,'o','color',colors{1});
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;
% --------------------39.375--------------------
clear tonal bb
rpm_des = 1200; 
phi_des = 39.375; 
diff_des = 0; 

loc = (contains(testmat.name, '201118'))|(contains(testmat.name, '201119'));
loc = loc&(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
end
figure(5)
subplot(2,1,1)
hold on
l = plot(colls(loc),tonal,'o','color',colors{2});
subplot(2,1,2)
hold on
l2 = plot(colls(loc),bb,'o','color',colors{2});
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;
% --------------------45--------------------
clear tonal bb
rpm_des = 1200; 
phi_des = 45; 
diff_des = 0; 

loc = (contains(testmat.name, '201118'))|(contains(testmat.name, '201119'));
loc = loc&(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
end
figure(5)
subplot(2,1,1)
hold on
l = plot(colls(loc),tonal,'o','color',colors{3});
subplot(2,1,2)
hold on
l2 = plot(colls(loc),bb,'o','color',colors{3});
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;
% --------------------50.625--------------------
clear tonal bb
rpm_des = 1200; 
phi_des = 50.625; 
diff_des = 0; 

loc = (contains(testmat.name, '201118'))|(contains(testmat.name, '201119'));
loc = loc&(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
end
figure(5)
subplot(2,1,1)
hold on
l = plot(colls(loc),tonal,'o','color',colors{4});
subplot(2,1,2)
hold on
l2 = plot(colls(loc),bb,'o','color',colors{4});
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;
% --------------------67.5--------------------
clear tonal bb
rpm_des = 1200; 
phi_des = 67.5; 
diff_des = 0; 

loc = (contains(testmat.name, '201118'))|(contains(testmat.name, '201119'));
loc = loc&(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
end
figure(5)
subplot(2,1,1)
hold on
l = plot(colls(loc),tonal,'o','color',colors{5});
subplot(2,1,2)
hold on
l2 = plot(colls(loc),bb,'o','color',colors{5});
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;
% --------------------90--------------------
clear tonal bb
rpm_des = 1200; 
phi_des = 90; 
diff_des = 0; 

loc = (contains(testmat.name, '201118'))|(contains(testmat.name, '201119'));
loc = loc&(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (phis == phi_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
end
figure(5)
subplot(2,1,1)
hold on
l = plot(colls(loc),tonal,'o','color',colors{6});
subplot(2,1,2)
hold on
l2 = plot(colls(loc),bb,'o','color',colors{6});
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;

subplot(2,1,1)
grid on
ylabel('Tonal OASPL, dB')
set(gca,'fontsize',16)
leg = unique(sort(phis));
l = legend(num2str(leg(2:end)),'location',[0.28,.94,.5,.05], 'orientation','horizontal');

subplot(2,1,2)
grid on
ylabel('Broadband OASPL, dB')
set(gca,'fontsize',16)
xlabel('Collective, deg')


%% VS PHIS
clear tonal bb oaspl
rpm_des = 1200; 
col_des = 10; 
diff_des = 0; 

loc = (contains(testmat.name, '201118')) | (contains(testmat.name, '201119'));
loc = loc& (phis ~= 2) &(rpms > rpm_des*.98) & (rpms < rpm_des*1.02) & (colls == col_des) & (diffs == diff_des);
plotdata = {data{loc}};
for i = 1:length(plotdata)
tonal(i,1) = plotdata{i}(3).tonal;
bb(i,1) = plotdata{i}(3).bb;
oaspl(i,1) = plotdata{i}(3).oaspl;
end
figure(3)
hold on
l = plot(phis(loc),db2mag(tonal)*20E-6,'s');
hold on
l2 = plot(phis(loc),db2mag(bb)*20E-6,'^');
l3 = plot(phis(loc),db2mag(oaspl)*20E-6,'o');
l3 = plot(phis(loc),sqrt((db2mag(bb)*20E-6).^2 +(db2mag(tonal)*20E-6).^2),'*');
l.MarkerFaceColor = l.Color;
l2.MarkerFaceColor = l2.Color;
l3.MarkerFaceColor = l3.Color;

legend('Tonal','Broadband','Total','location','SW')
grid on
xlabel('Azimuthal Spacing, deg')
ylabel('OASPL, dB')
set(gca,'fontsize',16)


