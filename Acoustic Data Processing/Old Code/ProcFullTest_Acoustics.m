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
calplots = true;
cal_db = 114;

testdate = '200227';
testletter = 'b';
Ntests = 10;
plots = false;

dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';

%% CALIBRATION 
caldata = CalProc(caldate, calletter,calsuffix,cal_db, calplots);

%% DATA
tests = struct('testdata',[]);
for n = 1:Ntests
    testname = [testletter '_' num2str(n)];
    tests(n).testdata = TestProc(testdate,testname,plots, caldata);
    
    disp(testname)
%     disp('press space to continue')
%     pause
end 
disp('done')

%% PLOT
for n = 1:Ntests
    figure()
    semilogx(tests(n).testdata(9).fvec, tests(n).testdata(9).dbdata)
    hold on
    semilogx(tests(n).testdata(9).ofilt12_fvec, tests(n).testdata(9).ofilt12_dbdata,'LineWidth', 1.2)
    semilogx(tests(n).testdata(9).ofilt3_fvec, tests(n).testdata(9).ofilt3_dbdata, 'LineWidth',1.2)
%     semilogx(tests(n).testdata(9).fvec, tests(n).testdata(9).dbadata)
    xlim([10^1 10^4]);
end

%%
plus = 0;
figure()
set(gca,'Fontsize',20')
for wnt = [10 2 3 5]
    semilogx(tests(wnt).testdata(9).ofilt12_fvec, tests(wnt).testdata(9).ofilt12_dbdata + plus,'Linewidth',1.2)
    hold on
    xlim([10^1 10^4]);
%     plus = plus + 10;
    grid on
    ylabel('Sound Pressure Level, dB')
    xlabel('Frequency, Hz')
    title('1200 RPM, 02/27/2020')
end
legend('Background','\theta_0 = 6 deg','\theta_0 = 8 deg','\theta_0 = 10 deg')

%% COMPILE CAL FACTORS
filename = [testdate '_test_' testletter '_MicCalibration.xlsx'];
CompileCalFactors(caldata,filename,dirname)
