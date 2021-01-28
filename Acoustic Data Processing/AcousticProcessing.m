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
warning off

%% INPUTS
directory = '/Users/chloe/Box/Chloe Lab Stuff/2020 Fall Stacked Rotor/Acoustic Tests';

%% PROCESSING
[testnames, testdata, caldata] = fAcProc(directory);
fprintf('\n\n%s\n\n', 'Processing done.');

%% PLOT
k=1;
RPM=990;
bladenumber = 2;
micnum = 3;

figure(1)
semilogx(testdata{k}(micnum).fvec, testdata{k}(micnum).dbdata)
hold on
semilogx(testdata{k}(micnum).ofilt12_fvec, testdata{k}(micnum).ofilt12_dbdata,'linewidth',1.1)
semilogx(testdata{k}(micnum).fvec_filt, testdata{k}(micnum).dbdata_filt,'k')

xlim([10^1 10^4]);
ylim([0 80])
xlabel('Frequency, Hz')
ylabel('dB')
% fplotperrev(RPM,bladenumber)