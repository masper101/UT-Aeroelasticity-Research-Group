% PROC MISC ACCCOUSTICS 
% CMJOHNSON 03/25/2020
% PROCESS SINGLE TEST ACOUSTIC DATA FILES USING CALIBRATION DATA FILES AND DATA FILES
% 
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

% clear; clc; %close all;      
dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200208/Audio Files';

chdir(dirname)
%% CALIBRATION 
% INPUTS
caldate = '200208';
calletter = 'a';
calsuffix = [];
calplots = false;
cal_db = 114;

caldata = CalProc(caldate, calletter,calsuffix,cal_db, calplots);

%% DATA
testdate = '200208';
testletter = 'a_cal';
plots = false;
Pdoubling = false;
testdata = TestProc(testdate,testletter,plots, caldata,Pdoubling);

%%
figure(23)
semilogx(testdata(9).fvec, testdata(9).dbdata);%,testdata(4).fvec, testdata(4).dbdata)
% hold on
% semilogx(testdata(9).fvec, testdata(9).dbAdata);%,testdata(4).fvec, testdata(4).dbdata)
% 
grid on
grid minor
xlabel('Frequency [Hz]')
ylabel('SPL [dB]')
xlim([10^1 10^4]);


%% COMPILE CAL FACTORS
% testletter = 'd';
% filename = [testdate '_test_' testletter '_MicCalibration.xlsx'];
% dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';
% CompileCalFactors(caldata,filename,dirname)
