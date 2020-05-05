% PROCESS SINGLE ACOUSTICS + LOADS
%
% CMJOHNSON 03052020
%
%

clear; clc; %close all
%% ACOUSTICS
caldate = '200208';
calletter = 'a';
calsuffix = '';
calplots = false;
cal_db = 114;

testdate = '200208';
testletter = 'a-4';
plots = false;

dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200208/Audio Files';
% dirname = '/Users/cmj2855/Box Sync/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';

run ProcMisc_Acoustics 
%% LOADS
directory = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200208/Loads Files';
conditions = [54	54	29.11]; %[T(Farhen), % humidity, P(in.Hg)]
flip = true;
testdate = '200208';
testletter = 'a';
streamingdatalabel = 'a-4';


run LoadsProcessing

%%
% k = 1;
% tofile = [StreamData.rho... 
%     AvgData.avg_cts_outer{1} ...
%     std(StreamData.Fz_outer{k}) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.sigma...
%     AvgData.err_cts_outer{1} ...
%     AvgData.avg_cps_outer{1} ...
%     std(StreamData.Mz_outer{k}) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.R / StreamData.sigma...
%     AvgData.err_cps_outer{1}...
%     AvgData.avg_cts_inner{1} ...
%     std(StreamData.Fz_inner{k}) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.sigma...
%     AvgData.err_cts_inner{1} ...
%     AvgData.avg_cps_inner{1} ...
%     std(StreamData.Mz_inner{k}) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.R / StreamData.sigma...
%     AvgData.err_cps_inner{1}...
%     testdata.oaspl];
% 
% raw = [[testdata(1).fvec]' [testdata.dbdata]];
% oct12 = [[testdata(1).ofilt12_fvec]' [testdata.ofilt12_dbdata]];
% oct3 = [[testdata(1).ofilt3_fvec]' [testdata.ofilt3_dbdata]];



th = [15:15:15*12, 15*12+36:36:15*12+36*4];
figure(5)
hold on
polar(th*pi/180, [testdata.oaspl],'-o')
figure(6)
hold on
plot(th*pi/180, max([testdata.dbdata]),'-o')

figure()
subplot(2,1,1)
plot_confidenceint(deg,RevData{1}.avg_cts_outer(1:l),RevData{1}.toterr_cts_outer(1:l),colors{n})
grid minor
ylabel('C_T / \sigma')
xlim([0,360])
% ylim([0.00,0.14])
title(title_name)
% yticks([0:.04:.14])
subplot(2,1,2)
plot_confidenceint(deg,RevData{1}.avg_cps_outer(1:l),RevData{1}.toterr_cps_outer(1:l),colors{n})
xlabel('\psi [deg]')
grid minor
ylabel('C_P / \sigma')
xlim([0,360])