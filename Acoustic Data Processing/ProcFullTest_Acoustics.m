% PROCESS FULL DATA SET 
% CMJOHNSON 03/03/2020
% PROCESS FULL TEST ACOUSTICS DATA USING CALIBRATION DATA FILES AND DATA FILES
% PLOTS MIC 9 FOR EACH TEST
% INPUTS
%     caldate                 -> calibration test date
%     calletter               -> calibration test letter
%     calsuffix               -> [] or anything added to end of "cal"
%     testdate                -> data test date
%     testletter              -> data test letter
%     Ntests                  -> number of tests taken for test_"testletter"
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
%         .dbdata

clear; clc; close all;

%% INPUTS
caldate = '200227';
calletter = 'a';
calsuffix = [];
calplots = false;
cal_db = 114;

testdate = '200227';
testletter = 'b';
Ntests = 8;
plots = false;

dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';

%% CALIBRATION 
caldata = CalProc(caldate, calletter,calsuffix, calplots);
caldata = CalFactor(caldata, cal_db);

%% DATA
tests = struct('testdata',[]);
for n = 1:Ntests
    testname = [testletter '_' num2str(n)];
    tests(n).testdata = TestProc(testdate,testname,plots, caldata);
    
    
    figure()
    semilogx(tests(n).testdata(9).fvec, tests(n).testdata(9).dbdata)
    xlim([10^1 10^4]);
    disp(testname)
%     disp('press space to continue')
%     pause
end 
disp('done')

%% COMPILE CAL FACTORS
filename = [testdate '_test_' testletter '_MicCalibration.xlsx'];
CompileCalFactors(caldata,filename,dirname)
