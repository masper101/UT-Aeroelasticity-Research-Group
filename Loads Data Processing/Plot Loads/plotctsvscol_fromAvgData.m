clear CT_data CTerr CTup CTuperr CTlo CTloerr CP_data CPerr CPlo CPup CPloerr CPuperr col col_uni
load('colors.mat')
AvgData_corr = AvgData; 

%% INPUTS
title_des = '';
RPM_des = 1200; 
phi_des = 2; 
diffcol_des = 0; 

upcolor = colors{5};
locolor = colors{3};
totcolor = colors{1};
% for i = 1:7
% plot([0,1],[i,i],'color',colors{i},'linewidth',4)
% hold on
% end

%% GET CONSTANTS
diffcols = MeanData.diffcols;
phis = MeanData.phis; 
col = MeanData.meancols;
RPMs = MeanData.RPMs;
col_uni = unique(col);
errs = [AvgData_corr.err_cts_outer{:}]';

%% GET DATA
for i = 1:length(col_uni)
    loc =(RPMs> RPM_des*.98)&(RPMs < RPM_des*1.02);
    loc = (col_uni(i) == col)&loc & (phis == phi_des) & (diffcols == diffcol_des);
    
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

%% PLOT
% ************************** CT **************************
figure(1)
subplot(2,1,1)
hold on
% errorbar(col_uni,CTlo,CTloerr, 's','color',locolor,'MarkerEdgeColor',locolor,'MarkerFaceColor',locolor,'LineWidth', 1)
hold on
% errorbar(col_uni,CTup,CTuperr,'^','color',upcolor,'MarkerEdgeColor',upcolor,'MarkerFaceColor',upcolor,'LineWidth', 1)
errorbar(col_uni,CT_data,CTerr,'o','color',totcolor,'MarkerEdgeColor',totcolor,'MarkerFaceColor',totcolor,'LineWidth', 1)
xlabel('Collective, \theta_0 [deg]')
ylabel('C_T/ \sigma')
legend('Lower','Upper','Total','location','northwest')
title(title_des)
set(gca,'FontSize',18)
% grid minor
grid on
hold on
ylim([-.02 0.16])
xlim([0,12])


% ************************** CP **************************
% figure(2)
subplot(2,1,2)
hold on
% errorbar(col_uni,-CPlo,CPloerr, 's','color',locolor,'MarkerEdgeColor',locolor,'MarkerFaceColor',locolor,'LineWidth', 1)
hold on
% errorbar(col_uni,CPup,CPuperr,'^','color',upcolor,'MarkerEdgeColor',upcolor,'MarkerFaceColor',upcolor,'LineWidth', 1)
errorbar(col_uni,CP_data,CPerr, 'o','color',totcolor,'MarkerEdgeColor',totcolor,'MarkerFaceColor',totcolor,'LineWidth', 1)
xlabel('Collective, \theta_0 [deg]')
ylabel('C_P/ \sigma')
legend('Lower','Upper','Total','location','northwest')
title(title_des)
set(gca,'FontSize',18)
% grid minor
grid on
hold on
ylim([-0.002 0.016])
xlim([0,12])

% ************************** CT vs CP **************************
figure(3)
hold on
errorbar(-CPlo,CTlo,CTloerr, CTloerr, CPloerr,CPloerr, 's','color',locolor,'MarkerEdgeColor',locolor,'MarkerFaceColor',locolor,'LineWidth', 1)
hold on
errorbar(-CPup,CTup,CTuperr, CTuperr,CPuperr,CPuperr,'^','color',upcolor,'MarkerEdgeColor',upcolor,'MarkerFaceColor',upcolor,'LineWidth', 1)
% errorbar(CP_data,CT_data,CTerr,CTerr,CPerr,CPerr, 'o','color',totcolor,'MarkerEdgeColor',totcolor,'MarkerFaceColor',totcolor,'LineWidth', 1)
ylabel('C_T/ \sigma')
xlabel('C_P/ \sigma')
legend('Lower','Upper','Total','location','northwest')
title(title_des)
set(gca,'FontSize',18)
grid minor
grid on
hold on
ylim([-0.02, 0.14])



%%
function x = sumsquares(y)
for i=1: length(y)
    x(i) = (y(i))^2;
end
x = sqrt(sum(x));
end