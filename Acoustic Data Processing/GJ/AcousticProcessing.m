% PROCESS MISC ACOUSTIC DATA 
% CMJOHNSON 06/08/2020
% PROCESS SINGLE TEST ACOUSTIC DATA FILES USING CALIBRATION DATA FILES AND DATA FILES
 
% INPUTS
%     testdate                -> calibration test date / data test date
%     testletter              -> calibration test letter / data test letter
%     calsuffix               -> [] or anything added to end of "cal"
%     plots = true or false   -> plots calibration files
%     filename                -> name of calibration xlsx sheet
%     dirname                 -> location of calibration xlsx sheet
% 
% OUTPUTS
%     caldata
%         .scale              -> max magnitude of wav file at desired calibration frequency
%         .calmag
%         .tvec
%         .wavdata
%         .fs
%         .fvec
%     testdata
%         .fvec
%         .fs
%         .wavdata
%         .tvec
%         .testmag
%         .Pdata [Pa]
%         .Pdata_t [Pa]       -> Pressure in time domain
%         .dbdata
%         .ofilt12_dbdata
%         .ofilt3_dbdata
%         .oaspl

% clear; clc; close all
clear all;
%warning off

%% INPUTS
directory = '../Fall2020AcousticData/';

addpath(pwd)
inputs.doubling = 'y';

%inputs.date = '201117'; inputs.test = 'f'; inputs.cal = 'a'; 
% inputs.testnum = '5'; %1200 RPM coll:0, i90
% inputs.testnum = '8'; %1200 RPM coll:10, i90
%  inputs.testnum = 'ref'; Background - 0RPM
    
%inputs.date = '201118'; inputs.test = 'b'; inputs.cal = 'a';
%    inputs.testnum = '5'; %1200 RPM coll:0, i90    
    inputs.testnum = '8'; % 1200 RPM coll:10, i90
%    inputs.testnum = '14 5 6 12 7 11 8 9'; % coll sweep i90 1200 RPM
%inputs.testnum = '8';
inputs.date = '201119'; 
%inputs.cal = 'i'; inputs.test = 'i'; inputs.testnum = '9'; % 1200 RPM
%coll:10, i28.125
%inputs.date = '201118'; inputs.cal = 'a'; inputs.test = 'd'; inputs.testnum = '9'; % 1200 RPM coll:10, i28
%inputs.cal = 'a'; inputs.test = 'b'; inputs.testnum = '8'; % 1200 RPM coll:10, i39.375
%inputs.cal = 'a'; inputs.test = 'd'; inputs.testnum = '8'; % 1200 RPM coll:10, i45
%inputs.cal = 'a'; inputs.test = 'f'; inputs.testnum = '8'; % 1200 RPM coll:10, i50.625
%inputs.cal = 'i'; inputs.test = 'h'; inputs.testnum = '4'; % 1200 RPM coll:10, i67.5
inputs.date = '201118'; inputs.cal = 'a'; inputs.test = 'b'; inputs.testnum = '8'; % 1200 RPM coll:10, i90


% set environment
env.temp = 20;
env.press= 101325;
env.hr = 30;
far.dist = 72.5;
far.dist_fac = 10;
%% PROCESSING
[testnames, testdata, caldata] = fAcProc(directory,env,far,inputs);
fprintf('\n\n%s\n\n', 'Processing done.');

%% PLOT
k=1;
RPM = 1200; %RPM=990;
bladenumber = 2;
micnum = 3;

figure(1); hold on;
plot(testdata{k}(micnum).tvec-7.4,testdata{k}(micnum).Pdata_t)


%figure(2); % vs elevtion
%plot(linspace(-90,90,16),[testdata{k}.oaspl])

figure(3);  % spectrum
%semilogx(tetestdata{k}(micnum).fvec, testdata{k}(micnum).dbdata); hold on
%semilogx(testdata{k}(micnum).ofilt12_fvec, testdata{k}(micnum).ofilt12_dbdata,'linewidth',1.1)
semilogx(testdata{k}(micnum).fvec_filt, testdata{k}(micnum).dbdata_filt,'k', 'displayname','Experiment'); hold on;
semilogx(testdata{k}(micnum).fvec_filt, testdata{k}(micnum).dBbb, 'displayname','Experiment filt'); hold on;
semilogx(testdata{k}(micnum).fvec_filt, testdata{k}(micnum).dBtl, 'displayname','Experiment filt'); hold on;

%semilogx(testdata{k}(micnum).fvec_filt, testdata{k}(micnum).dBfarA,'k', 'displayname','Experiment far'); hold on;

xlim([10^1 2*10^4]);
ylim([0 80])
xlabel('Frequency, Hz')
ylabel('SPL, dB \Delta f = 1Hz')
% fplotperrev(RPM,bladenumber)

%% save
exp = table(); %data structure for saving
% make vector for specific mic from multiple tests
for i = 1:length(testdata)
exp.names{i} = [testdata{i}(1).name];
exp.db(i,1) = [testdata{i}(micnum).oaspl];
exp.dbA(i,1) = [testdata{i}(micnum).oasplA];
exp.dBbb(i,1) = [testdata{i}(micnum).oasplbb];
exp.dBtl(i,1) = [testdata{i}(micnum).oaspltl];
exp.dbfar(i,1) = [testdata{i}(micnum).oasplfar];
exp.dbfarbb(i,1) = [testdata{i}(micnum).oasplfarbb];
exp.dbfartl(i,1) = [testdata{i}(micnum).oasplfartl];
exp.dbfarA(i,1) = [testdata{i}(micnum).oasplfarA];
exp.dbfarAbb(i,1) = [testdata{i}(micnum).oasplfarAbb];
exp.dbfarAtl(i,1) = [testdata{i}(micnum).oasplfarAtl];
end


figure(4);
plot(exp.db); hold on;
plot(exp.dBtl)
plot(exp.dBbb)


for i = 1:length(testdata)
    data{i}(1).name = [testdata{i}(1).name];
for micnum = 1:16
data{i}(micnum).f = [testdata{i}(micnum).fvec_filt];
data{i}(micnum).db = [testdata{i}(micnum).dbdata_filt];
data{i}(micnum).dbA = [testdata{i}(micnum).dbAdata_filt];
data{i}(micnum).oaspl = [testdata{i}(micnum).oaspl];
data{i}(micnum).oasplA = [testdata{i}(micnum).oasplA];
end
end