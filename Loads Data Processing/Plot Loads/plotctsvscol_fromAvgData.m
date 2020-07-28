clear CT_data CTerr CP_data CPerr col col_uni

load('colors.mat')
col = MeanData.meancols;
col_uni = unique(col);

for i = 1:length(col_uni)
    loc = col_uni(i) == col;

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

i = 1;
errorbar(col_uni,CTlo,CTloerr, 's','color',colors{2},'MarkerEdgeColor',colors{2},'MarkerFaceColor',colors{2},'LineWidth', 1)
hold on
errorbar(col_uni,CTup,CTuperr,'^','color',colors{3},'MarkerEdgeColor',colors{3},'MarkerFaceColor',colors{3},'LineWidth', 1)
errorbar(col_uni,CT_data,CTerr, '^','color',colors{i},'MarkerEdgeColor',colors{i},'MarkerFaceColor',colors{i},'LineWidth', 1)
xlabel('Collective, \theta_0 [deg]')
ylabel('C_T/ \sigma')
set(gca,'FontSize',18)
grid minor
hold on
ylim([-.01, 0.15])
xlim([-1,13])



%%
function x = sumsquares(y)
for i=1: length(y)
    x(i) = (y(i))^2;
end
x = sqrt(sum(x));
end