% PROCESS MISC LOADS DATA 

% *********************
%     POST-NOV 2020
% *********************

% CMJOHNSON UPDATED: 11/03/2020
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

%% INPUTS

directory = '\Users\admin-local\Desktop\Research\02 Data\Streaming';
directory = '/Users/chloe/Box/Chloe Lab Stuff/2021 Spring Stacked Rotor/Outdoor';
rotor = input('Rotor type [ Uber CCR ]: ', 's');

conditions = [54	29.88]; % [T(Farenh), % humidity, P(in.Hg)]

flip = false;
filename = 'Compiled_data_DIC_August_2019.xlsx';
write_directory = directory;

%% PROCESS

[MeanData,StreamData] = fLoadData(directory, rotor, flip,conditions);

[StreamData,SortedData] = fSortStream(StreamData);
RevData = fRevolutionAvg(SortedData);
AvgData = fTotalAvg(RevData,SortedData,StreamData);

% [CorrelatedData,RevData_corr] = fRemoveBadRevs(SortedData,RevData);
% AvgData_corr = fTotalAvg(RevData_corr,CorrelatedData,StreamData);

fprintf('\n\n%s\n\n', 'Processing done.');

% i = 6;
% mean([RevData.avg_Fx_outer{i}', RevData.avg_Fy_outer{i}', RevData.avg_Fz_outer{i}', RevData.avg_Mx_outer{i}', RevData.avg_My_outer{i}', RevData.avg_Mz_outer{i}'])
% mean([RevData.avg_Fx_inner{i}', RevData.avg_Fy_inner{i}', RevData.avg_Fz_inner{i}', RevData.avg_Mx_inner{i}', RevData.avg_My_inner{i}', RevData.avg_Mz_inner{i}'])
% 
% 
% i = 5; 
% mean([RevData.avg_Fx_outer{i}', RevData.avg_Fy_outer{i}',RevData.avg_Fz_outer{i}',RevData.avg_Mx_outer{i}', RevData.avg_My_outer{i}',RevData.avg_Mz_outer{i}'])
% mean([RevData.avg_Fx_inner{i}', RevData.avg_Fy_inner{i}',RevData.avg_Fz_inner{i}',RevData.avg_Mx_inner{i}', RevData.avg_My_inner{i}',RevData.avg_Mz_inner{i}'])

%% VISUALIZE OR WRITE TO FILE

worv = input('Write (w) or visualize (v) data ? ', 's'); 

switch worv
    case 'w'
        CompileData(MeanData,AvgData,filename,write_directory);
    case 'v'
        fSeeData(rotor, MeanData, SortedData, RevData);
    otherwise
end

%%
i = 2;
figure()
subplot(2,1,1)
hold on
plot(SortedData.azimuth{i}, RevData.avg_Fx_outer{i})
xlim([0 360])
title('F_x')
subplot(2,1,2)
hold on
plot(SortedData.azimuth{i}, RevData.avg_Fy_outer{i})
xlim([0 360])
title('F_y')

% figure()
% subplot(2,1,1)
% hold on
% plot(SortedData.azimuth{i}, RevData.avg_Fx_inner{i})
% xlim([0 360])
% title('F_x')
% subplot(2,1,2)
% hold on
% plot(SortedData.azimuth{i}, RevData.avg_Fy_inner{i})
% xlim([0 360])
% title('F_y')

figure()
subplot(2,1,1)
hold on
plot(SortedData.azimuth{i}, RevData.avg_Mx_outer{i})
xlim([0 360])
title('M_x')
subplot(2,1,2)
hold on
plot(SortedData.azimuth{i}, RevData.avg_My_outer{i})
xlim([0 360])
title('M_y')

% figure()
% subplot(2,1,1)
% hold on
% plot(SortedData.azimuth{i}, RevData.avg_Mx_inner{i})
% xlim([0 360])
% title('M_x')
% subplot(2,1,2)
% hold on
% plot(SortedData.azimuth{i}, RevData.avg_My_inner{i})
% xlim([0 360])
% title('M_y')