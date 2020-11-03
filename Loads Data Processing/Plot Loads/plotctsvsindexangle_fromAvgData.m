clear CT_data CTerr CP_data CPerr CTlo CTloerr CPlo CPloerr CTup CTuperr CPup CPuperr ctcp ctcperr col col_uni
load('colors.mat')
AvgData_corr = AvgData;

RPM_des = 1200; 
col_des = 12; 

% 4-BLADED ROTOR
CT_90 = 0.1281;
CP_90 = 0.0156;

phis = MeanData.phis; 
phis_uni = unique(phis); 
col = MeanData.meancols;
RPMs = MeanData.RPMs;

% CHECK FOR OUTLIERS
figure(12)
loc = (col == col_des); 
% errorbar(phis(loc),[AvgData_corr.avg_cts_total{loc}],[AvgData_corr.err_cts_total{loc}],'o')
errorbar(phis(loc),[AvgData_corr.avg_ctcp{loc}],[AvgData_corr.err_ctcp{loc}],'o')
hold on
loc = (col == col_des) &([AvgData_corr.err_ctcp{:}]'<.25);
errorbar(phis(loc),[AvgData_corr.avg_ctcp{loc}],[AvgData_corr.err_ctcp{loc}],'k.')
hold off


for i = 1:length(phis_uni)
    loc = (col == col_des) & (phis_uni(i) == phis) & ([AvgData_corr.err_cts_total{:}]'<0.01);%&(RPMs == RPM_des);

    CT_data(i) = mean([AvgData_corr.avg_cts_total{loc}]);
    CTerr(i) = sumsquares([AvgData_corr.err_cts_total{loc}]);
    CP_data(i) = mean([AvgData_corr.avg_cps_total{loc}]);
    CPerr(i) = sumsquares([AvgData_corr.err_cps_total{loc}]);
    
    CTlo(i) = mean([AvgData_corr.avg_cts_inner{loc}]);
    CTloerr(i) = sumsquares([AvgData_corr.err_cts_inner{loc}]);
    CPlo(i) = mean([AvgData_corr.avg_cps_inner{loc}]);
    CPloerr(i) = sumsquares([AvgData_corr.err_cps_inner{loc}]);
    
    CTup(i) = mean([AvgData_corr.avg_cts_outer{loc}]);
    CTuperr(i) = sumsquares([AvgData_corr.err_cts_outer{loc}]);
    CPup(i) = mean([AvgData_corr.avg_cps_outer{loc}]);
    CPuperr(i) = sumsquares([AvgData_corr.err_cps_outer{loc}]);
    
    loc = (col == col_des) & (phis_uni(i) == phis) & ([AvgData_corr.err_ctcp{:}]'<0.25);
    ctcperr(i) = sumsquares([AvgData_corr.err_ctcp{loc}]);    
end

% add -90 deg case
if sum(phis_uni==90)>0
    phis_uni(end+1) = -90;
    loc = (phis_uni == 90);
    CT_data(end+1) = CT_data(loc);
    CTerr(end+1) = CTerr(loc);
    CP_data(end+1) = CP_data(loc);
    CPerr(end+1) = CPerr(loc);
    
    CTlo(end+1) = CTlo(loc);
    CTloerr(end+1) = CTloerr(loc);
    CPlo(end+1) = CPlo(loc);
    CPloerr(end+1) = CPloerr(loc);
    
    CTup(end+1) = CTup(loc);
    CTuperr(end+1) = CTuperr(loc);
    CPup(end+1) = CPup(loc);
    CPuperr(end+1) = CPuperr(loc);
    
    ctcperr(end+1) = ctcperr(loc);
end

    
    

figure(1)
i = 1; %color of total
j = 1; %color of lower
k = 1; %color of upper

% LOWER
subplot(2,1,2)
hold on
errorbar(phis_uni,CTlo,CTloerr, 'o','color',colors{j},'MarkerEdgeColor',colors{j},'MarkerFaceColor',colors{j},'LineWidth', 1)
plot([-95,95],[CT_90,CT_90], '--','color',[0 0 0]+0.7, 'linewidth',1.2)
ylim([0.05, 0.17])
xlim([-95 95])
xticks([-90:15:90])
yticks([0.05:0.02:0.17])
ylabel('C_T/ \sigma')
xlabel('Index Angle, deg')
grid on
grid minor
set(gca, 'fontsize',14)

% UPPER
subplot(2,1,1)
hold on
errorbar(phis_uni,CTup,CTuperr,'o','color',colors{k},'MarkerEdgeColor',colors{k},'MarkerFaceColor',colors{k},'LineWidth', 1)
plot([-95,95],[CT_90,CT_90], '--','color',[0 0 0]+0.7, 'linewidth',1.2)
ylim([0.05, 0.17])
xlim([-95 95])
xticks([-90:15:90])
yticks([0.05:0.02:0.17])
xlabel('')
ylabel('C_T/ \sigma')
grid on
set(gca, 'fontsize',14)
legend('CFD','VVPM','Exp','location',[.85 .88 .1 .1])

% TOTAL
figure(2)
hold on
errorbar(phis_uni,CT_data,CTerr, 'o','color',colors{i},'MarkerEdgeColor',colors{i},'MarkerFaceColor',colors{i},'LineWidth', 1)
plot([-95,95],[CT_90,CT_90], '--','color',[0 0 0]+0.7, 'linewidth',1.2)
xlabel('Index Angle, deg')
ylabel('C_T/ \sigma')
set(gca,'FontSize',18)
grid on
hold on
ylim([0.05, 0.17])
xlim([-95 95])
xticks([-90:15:90])
yticks([0.05:0.02:0.17])
legend('CFD','VVPM','Exp','location',[.85 .86 .1 .1])

% CT/CP
figure(3)
hold on
errorbar(phis_uni,CT_data./CP_data,ctcperr, 'o','color',colors{i},'MarkerEdgeColor',colors{i},'MarkerFaceColor',colors{i},'LineWidth', 1)
plot([-95,95],[CT_90./CP_90,CT_90./CP_90], '--','color',[0 0 0]+0.7, 'linewidth',1.2)
xlabel('Index Angle, deg')
ylabel('C_T/ C_P')
set(gca,'FontSize',18)
grid on
hold on
ylim([5 12])
xlim([-95 95])
xticks([-90:15:90])
% yticks([0.05:0.02:0.17])
legend('CFD','VVPM','Exp','location',[.88 .88 .1 .1])


%%
function x = sumsquares(y)
for i=1: length(y)
    x(i) = (y(i))^2;
end
x = sqrt(sum(x));
end