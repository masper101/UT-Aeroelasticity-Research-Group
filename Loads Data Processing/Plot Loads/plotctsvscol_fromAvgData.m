clear CT_data CTerr CTup CTuperr CTlo CTloerr CP_data CPerr col col_uni
load('colors.mat')

RPM_des = 1200; 
phi_des = 2; 
diffcol_des = 0; 

diffcols = MeanData.diffcols;
phis = MeanData.phis; 
col = MeanData.meancols;
RPMs = MeanData.RPMs;
col_uni = unique(col);

for i = 1:length(col_uni)
    loc = (col_uni(i) == col) & (phis == phi_des) & (diffcols == diffcol_des) &(RPMs == RPM_des);

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
    
end

figure(1)
i = 6;
% errorbar(col_uni,CTlo,CTloerr, 's','color',colors{2},'MarkerEdgeColor',colors{2},'MarkerFaceColor',colors{2},'LineWidth', 1)
hold on
errorbar(col_uni,CTup,CTuperr,'^','color',colors{i},'MarkerEdgeColor',colors{i},'MarkerFaceColor',colors{i},'LineWidth', 1)
% errorbar(col_uni,CT_data,CTerr, '^','color',colors{i},'MarkerEdgeColor',colors{i},'MarkerFaceColor',colors{i},'LineWidth', 1)
xlabel('Collective, \theta_0 [deg]')
ylabel('C_T/ \sigma')
set(gca,'FontSize',18)
grid minor
grid on
hold on
% ylim([-.1, 0.26])
% xlim([-6,13])



%%
function x = sumsquares(y)
for i=1: length(y)
    x(i) = (y(i))^2;
end
x = sqrt(sum(x));
end