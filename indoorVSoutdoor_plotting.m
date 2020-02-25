%{ 
This script plots the data for the indoor and outdoor tests during the spring
2019 and spring 2020 testing campaigns. The script should be placed in the
same directory as the xlsx files containing the averaged data along with
its error values
%}

clearvars; close all; clc;
h = plot(1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9);
c = get(h,'Color');
close all

filenameIndoor = 'IsolatedRotor_Indoors.xlsx';
filenameOutdoor = 'IsolatedRotor_Outdoors_Spring2020.xlsx';
filenameIndoorOpen = 'IsolatedRotor_Indoors_Spring2020.xlsx';
indoorOpen2020 = xlsread(filenameIndoorOpen);
indoor2020 = xlsread(filenameIndoor);
outdoor2020 = xlsread(filenameOutdoor);

set(0, 'defaultAxesTickLabelInterpreter','latex'); set(0, 'defaultLegendInterpreter','latex');

%% CT vs CP Comparison
%Compare indoors to outdoor
figure(1)
hold on
errorbar(indoor2020(4,:),indoor2020(2,:),indoor2020(3,:),indoor2020(3,:),indoor2020(5,:),indoor2020(5,:),'o','Linewidth', 1)
errorbar(outdoor2020(4,:),outdoor2020(2,:),outdoor2020(3,:),outdoor2020(3,:),outdoor2020(5,:),outdoor2020(5,:),'o','LineWidth', 1)
xlabel('$C_P/ \sigma$','interpreter','latex')
ylabel('$C_T/ \sigma$', 'interpreter','latex')
set(gca,'FontSize',18)
legend('Indoors','Outdoor 2020','location','northwest')
grid minor
hold off

%Compare indoors (closed door) to indoor (open door)
figure(2)
hold on
errorbar(indoor2020(4,:),indoor2020(2,:),indoor2020(3,:),indoor2020(3,:),indoor2020(5,:),indoor2020(5,:),'o','Linewidth', 1)
errorbar(indoorOpen2020(4,:),indoorOpen2020(2,:),indoorOpen2020(3,:),indoorOpen2020(3,:),indoorOpen2020(5,:),indoorOpen2020(5,:),'o','LineWidth', 1)
xlabel('$C_P/ \sigma$','interpreter','latex')
ylabel('$C_T/ \sigma$', 'interpreter','latex')
set(gca,'FontSize',18)
legend('Indoors (closed)','Indoors (open)','location','northwest')
grid minor
hold off

%% CT vs Collective
%Compare indoors to outdoor
figure(3)
hold on
errorbar(indoor2020(1,:),indoor2020(2,:),indoor2020(3,:),'o','Linewidth', 1)
errorbar(outdoor2020(1,:),outdoor2020(2,:),outdoor2020(3,:),'o','LineWidth', 1)
xlabel('$\theta_0$ [deg]','interpreter','latex')
ylabel('$C_T/ \sigma$', 'interpreter','latex')
set(gca,'FontSize',18)
legend('Indoors','Outdoor 2020','location','northwest')
grid minor
hold off

%Compare indoors (closed door) to indoor (open door)
figure(4)
hold on
errorbar(indoor2020(1,:),indoor2020(2,:),indoor2020(3,:),'o','Linewidth', 1)
errorbar(indoorOpen2020(1,:),indoorOpen2020(2,:),indoorOpen2020(3,:),'o','LineWidth', 1)
xlabel('$\theta_0$','interpreter','latex')
ylabel('$C_T/ \sigma$', 'interpreter','latex')
set(gca,'FontSize',18)
legend('Indoors (closed)','Indoors (open)','location','northwest')
grid minor
hold off