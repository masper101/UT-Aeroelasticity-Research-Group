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

clear; clc; close all
warning off

%% INPUTS
directory = '/Users/chloe/Box/Chloe Lab Stuff/2021 Spring Stacked Rotor/Acoustics/zc_15';

%% PROCESSING
[testnames, testdata, caldata] = fAcProc(directory);
fprintf('\n\n%s\n\n', 'Processing done.');

%% PLOT
k=1;
RPM=1200;
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

%% save
for i = 1:length(testdata)
db(i,1) = [testdata{i}(3).oaspl];
dbA(i,1) = [testdata{i}(3).oasplA];
names{i,1} = [testdata{i}(1).name];
end

for i = 1:length(testdata)
    data{i}(1).name = [testdata{i}(1).name];
for micnum = 1:16
data{i}(micnum).f = [testdata{i}(micnum).fvec_filt];
data{i}(micnum).db = [testdata{i}(micnum).dbdata_filt];
data{i}(micnum).dbA = [testdata{i}(micnum).dbAdata_filt];
data{i}(micnum).oaspl = [testdata{i}(micnum).oaspl];
data{i}(micnum).oasplA = [testdata{i}(micnum).oasplA];
data{i}(micnum).tonal = [testdata{i}(micnum).tonal];
data{i}(micnum).bb = [testdata{i}(micnum).broadband];
end
end