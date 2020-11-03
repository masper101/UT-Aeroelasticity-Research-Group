function kappa = fInducedPower(MeanData, StreamData, AvgData)

% GET DATA TO CURVE FIT
col = MeanData.meancols;
col_uni = unique(col);

for i = 1:length(col_uni)
    loc = col_uni(i) == col;

    CT_data(i) = mean([AvgData.avg_cts_total{loc}]);
    CTerr(i) = sumsquares([AvgData.err_cts_total{loc}]);
    CP_data(i) = mean([AvgData.avg_cps_total{loc}]);
    CPerr(i) = sumsquares([AvgData.err_cps_total{loc}]);
    
    CTlo(i) = mean([AvgData.avg_cts_inner{loc}]);
    CTloerr(i) = sumsquares([AvgData.err_cts_inner{loc}]);
    CPlo(i) = mean([AvgData.avg_cps_inner{loc}]);
    CPloerr(i) = sumsquares([AvgData.err_cps_inner{loc}]);
    
    CTup(i) = mean([AvgData.avg_cts_outer{loc}]);
    CTuperr(i) = sumsquares([AvgData.err_cts_outer{loc}]);
    CPup(i) = mean([AvgData.avg_cps_outer{loc}]);
    CPuperr(i) = sumsquares([AvgData.err_cps_outer{loc}]);
end

figure()
load('colors.mat')
errorbar(CTlo,CPlo,CPloerr,CPloerr,CTloerr,CTloerr, 's','color',colors{2},'MarkerEdgeColor',colors{2},'MarkerFaceColor',colors{2},'LineWidth', 1)
hold on
errorbar(CTup,CPup,CPuperr,CPuperr,CTuperr,CTuperr,'^','color',colors{5},'MarkerEdgeColor',colors{5},'MarkerFaceColor',colors{5},'LineWidth', 1)
errorbar(CT_data,CP_data,CPerr,CPerr,CTerr,CTerr, '^','color',colors{1},'MarkerEdgeColor',colors{1},'MarkerFaceColor',colors{1},'LineWidth', 1)
ylabel('C_P/ \sigma')
xlabel('C_T/ \sigma')
set(gca,'FontSize',18)
grid minor
hold on



% CURVE FIT
% cps = kappa*sqrt(s)*cts^(3/2) / sqrt(2) + cp0/s
s = StreamData.sigma;
cf = 'a * sqrt(s) * x^(3/2) / sqrt(2) + b';
f1 = fit(CT_data,CP_data,cf);

plot(f1,CT_data,CP_data)









end



%%
function x = sumsquares(y)
for i=1: length(y)
    x(i) = (y(i))^2;
end
x = sqrt(sum(x));
end