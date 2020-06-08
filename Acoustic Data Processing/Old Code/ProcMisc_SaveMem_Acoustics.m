% PROC MISC ACCCOUSTICS SAVE MEMORY
% CMJOHNSON 03/03/2020
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
%         .calfactor
%     testdata
%         .fvec
%         .dbdata

clear; clc; %close all;      
dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';

chdir(dirname)
%% CALIBRATION 
% INPUTS
caldate = '200227';
calletter = 'a';
calsuffix = [];
cal_db = 114;

caldata = CalProc_SaveMem(caldate, calletter,calsuffix, cal_db);

%% DATA
testdate = '200227';
testletter = 'b_4';
testdata = TestProc_SaveMem(testdate,testletter, caldata);

%% PLOT
figure(22)
semilogx(testdata(9).fvec, testdata(9).dbdata)
hold on
l = semilogx(testdata(9).fvec, testdata(9).dbAdata);
l.Color(4)=0.3;
xlim([10^1 10^4]);


%% COMPILE CAL FACTORS
% testletter = 'd';
% filename = [testdate '_test_' testletter '_MicCalibration.xlsx'];
% dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';
% CompileCalFactors(caldata,filename,dirname)
