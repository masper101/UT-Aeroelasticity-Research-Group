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

clear; clc; %close all
warning off

%% INPUTS
directory = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';

%% PROCESSING
[caldata,testdate] = fCalProc(directory);
testdata = fAcProc(directory, testdate, caldata);

fprintf('\n\n%s\n\n', 'Processing done.');

