% REFLECTIONS

clear; clc; close all;

%% CALIBRATION
caldate = '200228';
calletter = 'a';
calsuffix = [];
micnums = [7];
cal_db = 114;
calplots = false;

caldata = CalProc_SingleMic(caldate, calletter,calsuffix,micnums,cal_db,calplots);


%% LOAD IMPULSE 
testdate = '200228';
testletter = 'a_2';
plots = false;
micnums = [7];
testdata_impulse = TestProc_SingleMic(testdate, testletter, micnums, caldata, plots);

%% PLOT
plot(testdata_impulse(micnums).tvec, testdata_impulse(micnums).wavdata)

%% LOAD REFLECTIONS
testdate = '200228';
testletter = 'a_3';
plots = false;
micnums = [7];
testdata_refl = TestProc_SingleMic(testdate, testletter, micnums, caldata, plots);

%% PLOT
hold on
plot(testdata_refl(micnums).tvec, testdata_refl(micnums).wavdata)
