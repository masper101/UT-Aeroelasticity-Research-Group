% PROCESS SINGLE ACOUSTICS + LOADS
%
% CMJOHNSON 03052020
%
%

clear; clc; %close all
title_name = '8 deg Collective';
%% ACOUSTICS
caldate = '200208';
calletter = 'a';
calsuffix = '';
calplots = true;
cal_db = 114;

testdate = '200208';
testletter = 'a_4';
plots = false;

dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200208/Audio Files';
% dirname = '/Users/cmj2855/Box Sync/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';

run ProcMisc_Acoustics 
%% LOADS
directory = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Loads Files/Isolated';
conditions = [34	54	29.11]; %[T(Farhen), % humidity, P(in.Hg)]
flip = false;
testdate = '200227';
testletter = 'a';
streamingdatalabel = 'a-3';


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


%% PLOT
th = [15:15:15*12, 15*12+36:36:15*12+36*4];
figure()
polarplot(th*pi/180, [testdata.oaspl],'-o')
grid on
title(['OASPL: ',title_name])
thetaticks(th)
thetaticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})



figure(23)
% semilogx(testdata(9).fvec, testdata(9).dbdata);%,testdata(4).fvec, testdata(4).dbdata)
hold on
% semilogx(testdata(9).fvec, testdata(9).dbAdata);%,testdata(4).fvec, testdata(4).dbdata)
semilogx(testdata(9).ofilt12_fvec, testdata(9).ofilt12_dbdata,'linewidth',1)
% semilogx(testdata(9).ofilt3_fvec, testdata(9).ofilt3_dbdata,'k-*','linewidth',1.2)
grid on
grid minor
xlabel('Frequency [Hz]')
ylabel('SPL [dB]')
xlim([10^1 10^4]);
title(['Mic 9: ', title_name])


load('colors.mat')
n=1;
num = find(strcmp(StreamData.names, [testdate,'_test_',streamingdatalabel,'.csv']));
figure()
subplot(2,1,1)
plot_confidenceint(SortedData.azimuth{1},RevData{num}.avg_cts_outer,RevData{num}.toterr_cts_outer,colors{n})
grid minor
ylabel('C_T / \sigma')
xlim([0,360])
ylim([0,0.14])
title(title_name)
yticks([0:.02:.14])
subplot(2,1,2)
plot_confidenceint(SortedData.azimuth{1},RevData{num}.avg_cps_outer,RevData{num}.toterr_cps_outer,colors{n})
xlabel('\psi [deg]')
grid minor
ylabel('C_P / \sigma')
xlim([0,360])
ylim([0 0.014])