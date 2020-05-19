% PROCESS MISC LOADS DATA 
% CMJOHNSON UPDATED: 03/02/2020
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

%directory = '/Users/sirohi/Desktop/Two-bladed loads/Streaming data_DIC_August_2019';
directory = '/Users/chloe/Box/Chloe Lab Stuff/Two-bladed loads/Horizontal_800RPM_Outdoor';
rotor = input('Rotor type [ Uber CCR ]: ', 's');
testletters = input('Test letters: ','s');
testletters = split(testletters, ' ');

conditions = [34	54	29.11]; %[T(Farenh), % humidity, P(in.Hg)]
flip = true;
filename = 'Compiled_data_DIC_August_2019.xlsx';
write_directory = directory;

%% PROCESS

[MeanData,StreamData] = fLoadData(directory, testletters, rotor, flip);
[StreamData,SortedData] = fSortStream(StreamData, conditions);
% <<<<<<< HEAD
RevData = RevolutionAvg(SortedData, StreamData);
[SortedData_corr, RevData] = fCheckCorrelation(SortedData, RevData);
% =======
% SortedData = CheckCorrelation(SortedData);
RevData_corr = RevolutionAvg(SortedData_corr,StreamData);
% >>>>>>> 634cc8543a157eb4f988775453768cb41b826301
AvgData = TotalAvg(RevData,StreamData);

fprintf('\n\n%s\n\n', 'Processing done.');
% 


%% VISUALIZE OR WRITE TO FILE

worv = input('Write (w) or visualize (v) data ? ', 's'); 

switch worv
    case 'w'
        CompileData(MeanData,AvgData,filename,write_directory);
    case 'v'
        fSeeData(rotor, MeanData, SortedData, RevData);
    otherwise
end

