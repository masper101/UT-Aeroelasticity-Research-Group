% PROCESS SINGLE ACOUSTICS + LOADS
%
% CMJOHNSON 03052020
%
%

clear; clc; %close all
%% ACOUSTICS
caldate = '200227';
calletter = 'd';
calsuffix = '2';
calplots = false;
cal_db = 114;

testdate = '200227';
testletter = 'd_cal2';
plots = false;

% dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';
dirname = '/Users/cmj2855/Box Sync/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';

run ProcMisc_Acoustics 
%% LOADS
directory = '/Users/cmj2855/Box Sync/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Loads Files/Isolated';
conditions = [37	54	29.11]; %[T(Farhen), % humidity, P(in.Hg)]
flip = true;
testdate = '200227';
testletter = 'b';
streamingdatalabel = 'b-8';
OMEGA = 1200/60*2*pi;

run Proc_SingleFile

%%
k = 1;
tofile = [StreamData.rho... 
    AvgData.avg_cts_outer{1} ...
    std(StreamData.Fz_outer{k}) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.sigma...
    AvgData.err_cts_outer{1} ...
    AvgData.avg_cps_outer{1} ...
    std(StreamData.Mz_outer{k}) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.R / StreamData.sigma...
    AvgData.err_cps_outer{1}...
    AvgData.avg_cts_inner{1} ...
    std(StreamData.Fz_inner{k}) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.sigma...
    AvgData.err_cts_inner{1} ...
    AvgData.avg_cps_inner{1} ...
    std(StreamData.Mz_inner{k}) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.R / StreamData.sigma...
    AvgData.err_cps_inner{1}...
    testdata.oaspl];

raw = [[testdata(1).fvec]' [testdata.dbdata]];
oct12 = [[testdata(1).ofilt12_fvec]' [testdata.ofilt12_dbdata]];
oct3 = [[testdata(1).ofilt3_fvec]' [testdata.ofilt3_dbdata]];



th = [15:15:15*12, 15*12+36:36:15*12+36*4];
figure(5)
hold on
polar(th*pi/180, [testdata.oaspl],'-o')
figure(6)
hold on
plot(th*pi/180, max([testdata.dbdata]),'-o')