% PROCESS MISC LOADS DATA 

% *********************
%     POST-NOV 2020
% *********************

% MASPER UDAPTES: 04/09/2021
% Sirohi 200416 reads in mean data file and then reads corresponding
% streaming files

% PROCESSES STREAMING DATA AND MEAN DATA FILE, CHECKS CORRELATION OF DATA 
% FOR ERRORS IN RECODING (MOTOR BUMPS), WRITES TO XLXS FILE
% 
% INPUTS
%     directory         -> location of streaming data files + corresponding mean data files 
%                        mean data files only required for writing to xlxs file
%     conditons = [Temperature [F], % Humidity, Pressure[in-Hg]]
%     flip      = true  -> inner load cell in same oriendtation as outer load cell
%               = false -> inner load cell is flipped with reference to outer load cell (small axial spacings)
%     filename          -> xlxs file name to write data to
%     write_directory   -> location to write xlsx file to
% 
% OUTPUTS
%     MeanData          -> structure containing each mean data file
%     StreamData        -> structure containing info from streaming data
%                          files; each cell = one mean data file
%     SortedData        -> structure containing streaming data sorted into matrices;
%                          each cell = one mean data file; each row matrix = one revolution
%                          calculates ct/sigma,cp/sigma, and FM's
%     RevData           -> cells containg structure of azimuthally averaged data 
%                          1 cell for each data set
%                          each cell contains avg and err for each variable in RevData
%     AvgData           -> single cell containing avgerage and error of
%                          each calculated variable in single streaming data file
%     XLSX FILE         -> with given file name, compiles data from AvgData
%                          and test conditions (colelctive, index angle, axial spacing) 
%                          from MeanData

clear; clc; %close all
warning off
load('colors.mat');

%% INPUTS
RPM      = input('RPM: ','s');
Nb       = input('Number of blades: ','s');
V_bus     = 175; %bus voltage [V]
f        = 10e3; %sampling freq [Hz]

directory = ('/Users/asper101/Box Sync/For Matt/Indoor Testing/');

conditions = [38	30]; % [% humidity, P(in.Hg)]
rotor = 'Uber';
flip = true;

%% PROCESS
%select transient or steady state processing
process = input('Transient or Steady State? [T/S]: ','s');

if process == 'T'
    filename = input('Test file names (YYMMDD_test_x-#): ','s');
    [StreamData] = fLoadData_transient(directory, rotor, flip, conditions,filename);
    
    %time vector [s]
    t       = linspace(0,size(StreamData.Fx_outer{1},1)/f,size(StreamData.Fx_outer{1},1))';                 %time vector
    trig    = round(StreamData.trigger{1},0);                                              %round trigger voltage to an integer value
    start   = find((trig == 5),1);                                              %find the point at which the trigger reads the counter
    t_start = t(start);
    t = t-t_start;
    
    [StreamData,SortedData,idx_az] = fSortStream_transient(StreamData);
    
    RevData = fRevolutionAvg(SortedData);
    AvgData = fTotalAvg(RevData,SortedData,StreamData);
    fprintf('\n\n%s\n\n', 'Processing done.');
    
    %plot
    transient_process(RevData,t,idx_az,V_bus,colors,Nb);
    
elseif process == 'S'
    filename = input('Test file names (YYMMDD_test_x): ','s');
    [MeanData,StreamData] = fLoadData(directory, rotor, flip, conditions);
    [StreamData,SortedData] = fSortStream(StreamData);
    
    RevData = fRevolutionAvg(SortedData);
    AvgData = fTotalAvg(RevData,SortedData,StreamData);
    fprintf('\n\n%s\n\n', 'Processing done.');
    
    %plotting and saving
    ss_process(AvgData,MeanData,filename,RPM,Nb,V_bus,colors);
    
end




