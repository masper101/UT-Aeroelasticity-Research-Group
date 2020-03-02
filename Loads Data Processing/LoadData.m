function [MeanData,StreamData] = LoadData(directory,flip)
% LOADS DATA FROM STREAMING DATA FILES AND MEAN DATA FILES
% 
% INPUTS
%     directory         -> location of streaming data files
%     flip = true       -> inner load cell in same oriendtation as outer load cell
%          = false      -> inner load cell is flipped with reference to outer load cell (small axial spacings)
% OUTPUTS
%     MeanData          -> read directly from meandata csv files
%        COLUMN 1     RPM
%        COLUMN 2     mean collective
%        COLUMN 3     differential collective
%        COLUMN 4     index angle
%        COLUMN 5     axial spacing
%        COLUMN 6     Fx_inner
%        COLUMN 7     Fy_inner
%        COLUMN 8     Fz_inner
%        COLUMN 9     Mx_inner
%        COLUMN 10    My_inner
%        COLUMN 11    Mz_inner
%        COLUMN 12    Fx_outer 
%        COLUMN 13    Fy_outer
%        COLUMN 14    Fz_outer
%        COLUMN 15    Mx_outer
%        COLUMN 16    My_outer
%        COLUMN 17    Mz_outer
%        COLUMN 18    |Ax| 
%        COLUMN 19    arg(Ax)	
%        COLUMN 20    |Ay|	
%        COLUMN 21    arg(Ay)
%        COLUMN 22    lower colelctive
%        COLUMN 23    upper collective
%        COLUMN 24    time stamp
%        COLUMN 25    corresponding streaming data file
% 
% 
% 
%     StreamData        -> structure containing info from streaming data
%                          files; each cell = one mean data file
%                     .names        -> name of each streaming data file
%        COLUMN 1     .Fx_outer     -> all data points recorded by labview
%        COLUMN 2     .Fy_outer
%        COLUMN 3     .Fz_outer
%        COLUMN 4     .Mx_outer
%        COLUMN 5     .My_outer
%        COLUMN 6     .Mz_outer
%        COLUMN 7     .Fx_inner
%        COLUMN 8     .Fy_inner
%        COLUMN 9     .Fz_inner
%        COLUMN 10    .Mx_inner
%        COLUMN 11    .My_inner
%        COLUMN 12    .Mz_inner
%        COLUMN 15    .encoder      -> azimuthal location of data point
%        COLUMN 16    .revolution   -> revolution number
%        COLUMN 17    .trigger      -> 0 = pre-trigger, 1 = post-trigger
%        COLUMN 18    .RPM          -> RPM recorded by labview

% SORT FILES IN STREAMING DATA AND MEAN DATA
Files = dir(directory);
FileName = {Files(:).name};

pattern = "mean";
TF = contains(FileName,pattern);
MeanData.names = FileName(TF);

pattern = "-";
TF = contains(FileName,pattern);
StreamData.names = FileName(TF);

% PROCESS STREAMING DATA
addpath(directory)
for k = 1:length(StreamData.names)
    data = readtable(StreamData.names{k});
    StreamData.Fx_outer{k} = data{:,1};         %A
    StreamData.Fy_outer{k} = data{:,2};         %B
    StreamData.Fz_outer{k} = data{:,3} * -1;    %C
    StreamData.Mx_outer{k} = data{:,4};         %D
    StreamData.My_outer{k} = data{:,5};         %E
    StreamData.Mz_outer{k} = data{:,6} * -1;    %F
    StreamData.Fx_inner{k} = data{:,7};         %G
    StreamData.Fy_inner{k} = data{:,8};         %H
    StreamData.Fz_inner{k} = data{:,9};         %I
    StreamData.Mx_inner{k} = data{:,10};        %J
    StreamData.My_inner{k} = data{:,11};        %K
    StreamData.Mz_inner{k} = data{:,12}* -1;    %L
    
    StreamData.encoder{k} = data{:,15};         %O
    StreamData.revolution{k} = data{:,16};      %P
    StreamData.trigger{k} = data{:,17};         %Q
    StreamData.RPM{k} = data{:,18};             %R
    if (flip)
        StreamData.Fz_inner{k} = StreamData.Fz_inner{k}*-1;
    end
end
    

for k = 1:length(MeanData.names)
    MeanData.data{k} = readtable(MeanData.names{k}, 'TextType', 'string');
end

    
