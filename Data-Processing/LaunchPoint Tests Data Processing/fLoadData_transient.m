function [StreamData] = fLoadData_transient(directory, rotor, flip,conditions,fname)
% LOADS DATA FROM STREAMING DATA FILES AND MEAN DATA FILES
% 
% INPUTS
%     directory         -> location of mean data files
%                          streaming data files are in subdirectory
%                          "streaming"
%     flip = true       -> inner load cell in same oriendtation as outer load cell
%          = false      -> inner load cell is flipped with reference to outer load cell (small axial spacings)
% OUTPUTS
%     MeanData          -> read directly from meandata csv files
%        COLUMN 1     RPM
%        COLUMN 2     mean collective
%        COLUMN 3     differential collective
%        COLUMN 4     upper collective
%        COLUMN 5     lower collective
%        COLUMN 6     axial spacing
%        COLUMN 7     index angle
%        COLUMN 8     corresponding streaming data file
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
%        COLUMN 13    .ax
%        COLUMN 14    .ay
%        COLUMN 15    .encoder      -> azimuthal location of data point
%        COLUMN 16    .current 1
%        COLUMN 17    .current 2                    
%        COLUMN 18    .revolution   -> revolution number


%% MESSAGES

fprintf('\n%s\n', [ rotor ' rotor. Reading files in ' directory ]);

%% CHANGE TO DIRECTORY WHERE THE FILES LIVE

pdir = pwd;
cd(directory);

%% DECLARE QUANTITIES IN STREAMING DATA FILE

switch(rotor)
    case 'CCR'
        Fxocol = 1;          % Fx_outer column
        Fyocol = 2;          % Fy_outer column
        Fzocol = 3;          % Fz_outer column
        Mxocol = 4;          % Mx_outer column
        Myocol = 5;          % My_outer column
        Mzocol = 6;          % Mz_outer column
        Fxicol = 7;          % Fx_inner column
        Fyicol = 8;          % Fy_inner column
        Fzicol = 9;          % Fz_inner column
        Mxicol = 10;          % Mx_inner column
        Myicol = 11;          % My_inner column
        Mzicol = 12;          % Mz_inner column
        t1icol = 17;          % Pitch 1 inner column
        t2icol = 18;          % Pitch 2 inner column
        t1ocol = 19;          % Pitch 1 outer column
        t2ocol = 20;          % Pitch 2 outer column
        pr1icol = 13;          % Push rod 1 inner column
        pr2icol = 14;          % Push rod 2 inner column
        pr1ocol = 14;          % Push rod 1 outer column
        pr2ocol = 16;          % Push rod 2 outer column
        axcol = 21;           % mag Ax column
        aycol = 22;           % mag Ay column
        enccol = 25;          % encoder angle column
        revcol = 26;          % revolution column
%         trigcol = 25;         % trigger column
    case 'Uber'
        Fxocol = 1;          % Fx_outer column
        Fyocol = 2;          % Fy_outer column
        Fzocol = 3;          % Fz_outer column
        Mxocol = 4;          % Mx_outer column
        Myocol = 5;          % My_outer column
        Mzocol = 6;          % Mz_outer column
        Fxicol = 7;          % Fx_inner column
        Fyicol = 8;          % Fy_inner column
        Fzicol = 9;          % Fz_inner column
        Mxicol = 10;         % Mx_inner column
        Myicol = 11;         % My_inner column
        Mzicol = 12;         % Mz_inner column
        axcol = 13;          % mag Ax column
        aycol = 14;          % mag Ay column
        enccol = 15;         % encoder angle column
        curr1col = 16;       % current 1 column
        curr2col = 17;       % current 2 column
        revcol = 18;         % revolution column
    otherwise
        disp('Unknown rotor')
        return;
end
        

%% FIND NAMES OF STREAMING FILES AND ASSIGN OPERATING VARIABLES
T_F = input('Temperature [F]: ');
T = (T_F - 32)*5/9 + 273.15; % [Kelvin]
humid = conditions(1);
P = conditions(2)*101325/29.9212; % [Pa]
R_air = 287.05; % INDIVIDUAL GAS CONSTANT
rho = P/R_air/T;

StreamData.names = {strcat(fname,'.csv')};

fprintf('\n%s\n', 'Checking streaming files ...');

% remove rows corresponding to files that dont exist
row2rm = false(length(StreamData.names),1);   % vector of row numbers to remove
for ii = 1:length(StreamData.names)
    if ~isfile(StreamData.names{ii})
        row2rm(ii) = true;
        fprintf('\t%s\n', ['Missing file : ' StreamData.names{ii}]);
    end
end
StreamData.names(row2rm,:) = [];


%% LOAD AND PROCESS STREAMING FILES
nfiles = 1;
fprintf('\n%s\n', 'Reading streaming files');

for k = 1:nfiles
    StreamData.Fx_outer{k} = [];
    StreamData.Fy_outer{k} = [];
    StreamData.Fz_outer{k} = [];
    StreamData.Mx_outer{k} = [];
    StreamData.My_outer{k} = [];
    StreamData.Mz_outer{k} = [];
    StreamData.Fx_inner{k} = [];
    StreamData.Fy_inner{k} = [];
    StreamData.Fz_inner{k} = [];
    StreamData.Mx_inner{k} = [];
    StreamData.My_inner{k} = [];
    StreamData.Mz_inner{k} = [];
    StreamData.ax{k} = [];
    StreamData.ay{k} = [];
    StreamData.encoder{k} = [];
    StreamData.curr1{k} = [];
    StreamData.curr2{k} = [];
    StreamData.revolution{k} = [];
    StreamData.trigger{k} = [];
    StreamData.nrevs{k} = [];
    
    fprintf('\t%s', ['- ' StreamData.names{k} ' ... ']);

    data = readtable(StreamData.names{k});
    StreamData.Fx_outer{k} = data{:,Fxocol};         %A
    StreamData.Fy_outer{k} = data{:,Fyocol};         %B
    StreamData.Fz_outer{k} = data{:,Fzocol} * -1;    %C
    StreamData.Mx_outer{k} = data{:,Mxocol};         %D
    StreamData.My_outer{k} = data{:,Myocol};         %E
    StreamData.Mz_outer{k} = data{:,Mzocol} * -1;      %F
    StreamData.Fx_inner{k} = data{:,Fxicol};         %G
    StreamData.Fy_inner{k} = data{:,Fyicol};         %H
    StreamData.Fz_inner{k} = data{:,Fzicol};         %I
    StreamData.Mx_inner{k} = data{:,Mxicol};         %J
    StreamData.My_inner{k} = data{:,Myicol};         %K
    StreamData.Mz_inner{k} = data{:,Mzicol};         %L
    StreamData.ax{k} = data{:,axcol};                %M
    StreamData.ay{k} = data{:,aycol};                %N
    StreamData.encoder{k} = data{:,enccol};          %W
    StreamData.curr1{k} = data{:,curr1col};          %W
    StreamData.curr2{k} = data{:,curr2col};          %W
    StreamData.revolution{k} = data{:,revcol};       %X
    StreamData.trigger{k} = data{:,18};

    fprintf('%s\n', 'Ok');

    if (~flip)
        StreamData.Fz_outer{k} = StreamData.Fz_outer{k}*-1;
        StreamData.Mz_outer{k} = StreamData.Mz_outer{k}*-1;
    end
    
    StreamData.rho{k} = rho;
    
    %% CREATE REV COUNTER
    revnum = 0;
    for i = 1:length(StreamData.encoder{k})-1
        StreamData.revolution{k}(i,1) = revnum;
        if (StreamData.encoder{k}(i) > 359)&& (StreamData.encoder{k}(i+1) < 1)
            revnum = revnum + 1; 
        end
    end
    StreamData.revolution{k}(length(StreamData.encoder{k}),1) = revnum;
    StreamData.nrevs{k} = revnum;
end

cd(pdir);   % return to original directory

end

    
