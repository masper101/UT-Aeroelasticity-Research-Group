%-------------------------------------------------------------------------
% reads all the streaming data files and saves the pitch angles
% to a structure
%
% ignores file header
%
% streaming data files should be in the same folder as this code
%
% sirohi 191127
%-------------------------------------------------------------------------
clear all
close all

files = dir('*.csv');
nfiles = length(files);   % first two files are directories

theta_data = struct('fnames',[],'theta1',[],'theta2',[]);

fs = 10e3;          % sampling frequency, Hz

for ii = 1:nfiles,
    ff = files(ii).name;
    data = readtable(ff);
    theta_data(ii).fnames = strtok(ff,'.');
    theta_data(ii).theta1 = data.Var15;
    theta_data(ii).theta2 = data.Var16;
    npts = length(theta_data(ii).theta1);
    theta_data(ii).tvec = [0:1/fs:(npts-1)/fs]';
end

save('pa.mat', 'theta_data'); 