% PROC MISC ACCCOUSTICS
% PROC MISC ACOUSTICS
% CMJOHNSON 03/03/2020
% PROCESS SINGLE TEST ACOUSTIC DATA FILES USING CALIBRATION DATA FILES AND DATA FILES
% 
% INPUTS
%     testdate                -> calibration test date / data test date
%     testletter              -> calibration test letter / data test letter
%     calsuffix               -> [] or anything added to end of "cal"
%     plots = true or false   -> plots calibration files
%     filename                -> name of calibration xlsx sheet
%     dir                     -> location of calibration xlsx sheet
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
%         .dbdata

      

clear; clc; %close all;

%% CALIBRATION 
% INPUTS
testdate = '200227';
testletter = 'd';
calsuffix = [];
plots = false;
cal_db = 114;

caldata = CalProc(testdate, testletter,calsuffix, plots);
caldata = CalFactor(caldata, cal_db);

%% DATA
testdate = '200227';
testletter = 'd_4';
plots = false;
testdata = TestProc(testdate,testletter,plots, caldata);

figure(22)
semilogx(testdata(9).fvec, testdata(9).dbdata)
xlim([10^1 10^4]);


%% COMPILE CAL FACTORS
testletter = 'd';
filename = [testdate '_test_' testletter '_MicCalibration.xlsx'];
dir = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';
CompileCalFactors(caldata,filename,dir)
dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';
CompileCalFactors(caldata,filename,dirname);
