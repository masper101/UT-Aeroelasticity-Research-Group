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
<<<<<<< HEAD
%         .fvec               -> frequency vector (1 x 240000)
%         .fs                 -> sampling frequency (48000 Hz)
%         .wavdata            -> data in .wav file (480000 x 1)
%         .tvec               -> time vector (1 x 240000)
%         .testmag            -> magnitudes of .wav file in freq. domain
%                                (240000 x 1)
%         .Pdata [Pa]         -> pressure magnitudes in freq.
%                                domain (240000 x 1)
%         .dbdata             -> pressure magnitudes in freq. domain
%                                converted to dB (240000 x 1)
%         .pvst [Pa]          -> pressure in time domain (240000 x 1)
%   

clear; clc; close all;
=======
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

clear; clc; %close all;      
dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200208/Audio Files';
>>>>>>> 5c46d2613a24534a5da69cd321debfb4f3dac8ac

chdir(dirname)
%% CALIBRATION 
% INPUTS
<<<<<<< HEAD
testdate = '200208';
testletter = 'b';
=======
caldate = '200208';
calletter = 'a';
>>>>>>> 5c46d2613a24534a5da69cd321debfb4f3dac8ac
calsuffix = [];
calplots = false;
cal_db = 114;

caldata = CalProc(caldate, calletter,calsuffix,cal_db, calplots);

%% DATA
testdate = '200208';
<<<<<<< HEAD
testletter = 'pop_1';
=======
testletter = 'a_3';
>>>>>>> 5c46d2613a24534a5da69cd321debfb4f3dac8ac
plots = false;
testdata = TestProc(testdate,testletter,plots, caldata);

figure(22)
<<<<<<< HEAD
micnum = 9;
semilogx(testdata(micnum).fvec, testdata(micnum).dbdata); grid;
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');
legend(['Mic ' num2str(micnum)]);
=======
semilogx(testdata(9).fvec, testdata(9).dbdata)
hold on
semilogx(testdata(9).fvec, testdata(9).dbAdata)

>>>>>>> 5c46d2613a24534a5da69cd321debfb4f3dac8ac
xlim([10^1 10^4]);

figure(23)
micnum = 9;
plot(testdata(micnum).tvec, testdata(micnum).pvst); grid;
xlabel('Time, s');
ylabel('Pressure, Pa');
legend(['Mic ' num2str(micnum)]);
ylim([-10 10]);

figure(24)
micnum = 9;
Nb = 1024; % number of blocks
ov = 0.5;   % overlap ratio of blocks
lb = floor( length(testdata(micnum).wavdata) /(Nb -(Nb-1)*ov) );
nfft = max(256, 2^nextpow2(lb));   % number of points to use for FFT
spectrogram(testdata(micnum).wavdata, blackman(lb), floor(ov*lb), nfft, 48000, 'power');

<<<<<<< HEAD
% %% COMPILE CAL FACTORS
% testletter = 'd';
% filename = [testdate '_test_' testletter '_MicCalibration.xlsx'];
% dirname = ['./Uber Acoustics ' testdate '/Audio Files/'];
% CompileCalFactors(caldata,filename,dirname);
=======
%% COMPILE CAL FACTORS
% testletter = 'd';
% filename = [testdate '_test_' testletter '_MicCalibration.xlsx'];
% dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';
% CompileCalFactors(caldata,filename,dirname)
>>>>>>> 5c46d2613a24534a5da69cd321debfb4f3dac8ac
