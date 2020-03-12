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

%% CALIBRATION 
% INPUTS
testdate = '200208';
testletter = 'b';
calsuffix = [];
plots = false;
cal_db = 114;

caldata = CalProc(testdate, testletter,calsuffix, plots);
caldata = CalFactor(caldata, cal_db);

%% DATA
testdate = '200208';
testletter = 'pop_1';
plots = false;
testdata = TestProc(testdate,testletter,plots, caldata);

figure(22)
micnum = 9;
semilogx(testdata(micnum).fvec, testdata(micnum).dbdata); grid;
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');
legend(['Mic ' num2str(micnum)]);
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

% %% COMPILE CAL FACTORS
% testletter = 'd';
% filename = [testdate '_test_' testletter '_MicCalibration.xlsx'];
% dirname = ['./Uber Acoustics ' testdate '/Audio Files/'];
% CompileCalFactors(caldata,filename,dirname);
