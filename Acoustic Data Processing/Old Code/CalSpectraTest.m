clear; clc; %close all;      
dirname = '/Users/chloe/Box/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Audio Files';

chdir(dirname)
%% CALIBRATION 
% INPUTS
caldate = '200227';
calletter = 'a';
calsuffix = [];
calplots = false;
cal_db = 114;

caldata = CalProc(caldate, calletter,calsuffix,cal_db, calplots);
