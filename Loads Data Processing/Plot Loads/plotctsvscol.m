% PLOT DATA FROM XLSX FILE
% CMJOHNSON UPDATES:03/02/2020
%
%INPUTS
%     name     -> file to plot 
%                ** sheet names with format "Ind Ang == XXX, RPM = XXX" **
%     phi_des  -> RPM to plot
%     RPM_des  -> index angle to plot
%     isolated -> if true, only plots outer rotor

clear; clc; %close all
load('colors.mat')

%% INPUTS
name = 'IsolatedRotor_Outdoors_200227.xlsx';
phi_des = 2;
RPM_des = 1200;
isolated = true;

addpath('/Users/cmj2855/Box Sync/Chloe Lab Stuff/Acoustics Spring 2020/Compiled Data')
%% 
[~,sheet_name]=xlsfinfo(name);

for k=1:numel(sheet_name)
    data{k}=xlsread(name,sheet_name{k});
end

for i= 1:length(sheet_name)
    ind_str = extractBetween(sheet_name{i},'Ind Ang = ',',');
    phi_data(i) = str2num(ind_str{1});
    
    RPM_str = extractAfter(sheet_name{i},'RPM = ');
    RPM_data(i) = str2num(RPM_str);
end

for i = 1:length(data)
    if phi_data(i) == phi_des       %CHOSE INDEX ANGLE TO PLOT
        if RPM_data(i) == RPM_des   %CHOSE RPM TO PLOT
            index = i;              %DESIRED DATA SET
        end
    end
end

col = data{1,index}(2,:);
col_uni = unique(col);

for i = 1:length(col_uni)
    ind = col_uni(i) == col;
    CTup(i) = mean(data{index}(3,ind));
    CTuperr(i) = sumsquares(data{index}(4,ind));
    CPup(i) = mean(data{index}(5,ind));
    CPuperr(i) = sumsquares(data{index}(6,ind));
    FMup(i) = mean(data{index}(7,ind));
    FMuperr(i) = sumsquares(data{index}(8,ind));
    
    CTlo(i) = mean(data{index}(10,ind));
    CTloerr(i) = sumsquares(data{index}(11,ind));
    CPlo(i) = mean(data{index}(12,ind));
    CPloerr(i) = sumsquares(data{index}(13,ind));
    FMlo(i) = mean(data{index}(14,ind));
    FMloerr(i) = sumsquares(data{index}(15,ind));
    
    CT_data(i) = mean(data{index}(17,ind));
    CTerr(i) = sumsquares(data{index}(18,ind));
    CP_data(i) = mean(data{index}(19,ind));
    CPerr(i) = sumsquares(data{index}(20,ind));
    FM_data(i) = mean(data{index}(21,ind));
    FMerr(i) = sumsquares(data{index}(22,ind));
    
end


%%
figure(2)
set(0,'defaultlegendinterpreter','latex')
set(0,'defaultAxesTickLabelInterpreter','latex')

hold on

errorbar(col_uni,CTup,CTuperr,'^','color',colors{4},'MarkerEdgeColor',colors{4},'MarkerFaceColor',colors{4},'LineWidth', 1)
if (~isolated)
errorbar(col_uni,CTlo,CTloerr, 's','color',colors{2},'MarkerEdgeColor',colors{2},'MarkerFaceColor',colors{2},'LineWidth', 1)
errorbar(col_uni,CT_data,CTerr, 'o','color',colors{1},'MarkerEdgeColor',colors{1},'MarkerFaceColor',colors{1},'LineWidth', 1)
legend('Upper','Lower','Total','location','northwest')
end

xlabel('$\theta_0$ [deg]','interpreter','latex')
ylabel('$C_T/ \sigma$','interpreter','latex')
set(gca,'FontSize',18)
grid minor
% xlim([-0.0001, 0.11])

%------------------------------
figure(3)
set(0,'defaultlegendinterpreter','latex')
set(0,'defaultAxesTickLabelInterpreter','latex')

hold on

errorbar(col_uni,CPup,CPuperr,'^','color',colors{4},'MarkerEdgeColor',colors{4},'MarkerFaceColor',colors{4},'LineWidth', 1)
if (~isolated)
errorbar(col_uni,CPlo,CPloerr, 's','color',colors{2},'MarkerEdgeColor',colors{2},'MarkerFaceColor',colors{2},'LineWidth', 1)
errorbar(col_uni,CP_data,CPerr, 'o','color',colors{1},'MarkerEdgeColor',colors{1},'MarkerFaceColor',colors{1},'LineWidth', 1)
legend('Upper','Lower','Total','location','northwest')
end

xlabel('$\theta_0$ [deg]','interpreter','latex')
ylabel('$C_P/ \sigma$','interpreter','latex')
set(gca,'FontSize',18)
grid minor
% xlim([-0.0001, 0.11])

%%
function x = sumsquares(y)
for i=1: length(y)
    x(i) = (y(i))^2;
end
x = sqrt(sum(x));
end
