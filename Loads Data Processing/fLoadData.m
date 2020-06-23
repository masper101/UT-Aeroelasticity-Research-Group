function [MeanData,StreamData] = fLoadData(directory, testletters, rotor, flip)
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

%% MESSAGES

fprintf('\n%s\n', [ rotor ' rotor. Reading files in ' directory ]);

%% CHANGE TO DIRECTORY WHERE THE FILES LIVE

pdir = pwd;
%eval(['cd ''' directory '''']);
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
        t1icol = 13;          % Pitch 1 inner column
        t2icol = 14;          % Pitch 2 inner column
        t1ocol = 15;          % Pitch 1 outer column
        t2ocol = 16;          % Pitch 2 outer column
        pr1icol = 17;          % Push rod 1 inner column
        pr2icol = 18;          % Push rod 2 inner column
        pr1ocol = 19;          % Push rod 1 outer column
        pr2ocol = 20;          % Push rod 2 outer column
        axcol = 21;           % mag Ax column
        aycol = 22;           % mag Ay column
        enccol = 23;          % encoder angle column
        revcol = 24;          % revolution column
        trigcol = 25;         % trigger column
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
        revcol = 16;         % revolution column
        trigcol = 17;        % trigger column
    otherwise
        disp('Unknown rotor')
        return;
end
        
%% LOAD MEAN DATA FILES

Files = dir();
FileName = {Files.name};

for ii = 1:length(testletters)
    if strcmp(testletters{ii}, 'all')
        testletters{ii} = ' mean';
    else
        testletters{ii} = ['_' testletters{ii} ' mean'];
    end
end
TF = contains(FileName,testletters);
MeanData.names = FileName(TF);

mdata = table(); % assemble a table with all the mean data
for im = 1:length(MeanData.names) % need to fix reading multiple mean files
    fprintf('%s\t', ['Loading mean data file : ' MeanData.names{im} ' ...']);
    opts = detectImportOptions(MeanData.names{im});
    opts.DataLines = [2 Inf];
    opts.VariableNamesLine = 1;
    if im>1
        opts.VariableNames = vnames;
    end
    if im == 1
        MeanData.data{im} = readtable(MeanData.names{im}, opts, 'ReadVariableNames', true);
        vnames = MeanData.data{im}.Properties.VariableNames;
    else
        MeanData.data{im} = readtable(MeanData.names{im}, opts, 'ReadVariableNames', false);
    end
    mdata = vertcat(mdata, MeanData.data{im});
end    

%% FIND NAMES OF STREAMING FILES AND ASSIGN OPERATING VARIABLES

StreamData.names = mdata{:,'Path'};

fprintf('%s\n', 'Checking streaming files ...');

% remove rows corresponding to files that dont exist
row2rm = false(length(StreamData.names),1);   % vector of row numbers to remove
for ii = 1:length(StreamData.names)
    if ~isfile(StreamData.names{ii})
        row2rm(ii) = true;
        fprintf('\t%s\n', ['Missing file : ' StreamData.names{ii}]);
    end
end
mdata(row2rm,:) = [];
StreamData.names(row2rm,:) = [];

% find nominal RPM : actual RPM within closest 5 RPM. 898 -> 900, 901 -> 900 
MeanData.RPMs = (round(mdata{:,'RPM'}/5))*5;  
    
switch (rotor)
    case 'Uber'
        MeanData.meancols = mdata{:,'MeanCollective'};
        MeanData.diffcols = mdata{:,'Diff_Collective'};
        MeanData.zcs = mdata{:,'AxialSpacing'};
        MeanData.phis = mdata{:,'IndexAngle'};
    case 'CCR'
        % find nominal inner collective : round to closest integer 
        MeanData.cols_in = round((mdata{:,'Pitch1Inner'} + mdata{:,'Pitch2Inner'})/2);
        % find nominal outer collective : round to closest integer 
        MeanData.cols_out = round((mdata{:,'Pitch1Outer'} + mdata{:,'Pitch1Outer'})/2);
end

%% LOAD AND PROCESS STREAMING FILES

%cd('streaming');   % enter streaming files directory 
[nfiles, ~] = size(mdata);

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
    StreamData.encoder{k} = [];
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
    StreamData.Mz_outer{k} = data{:,Mzocol}*-1;         %F
    StreamData.Fx_inner{k} = data{:,Fxicol};         %G
    StreamData.Fy_inner{k} = data{:,Fyicol};         %H
    StreamData.Fz_inner{k} = data{:,Fzicol};         %I
    StreamData.Mx_inner{k} = data{:,Mxicol};         %J
    StreamData.My_inner{k} = data{:,Myicol};         %K
    StreamData.Mz_inner{k} = data{:,Mzicol};         %L
    
    StreamData.encoder{k} = data{:,enccol};          %W
    StreamData.revolution{k} = data{:,revcol};       %X
    StreamData.trigger{k} = data{:,trigcol};         %Q
    StreamData.nrevs{k} = StreamData.revolution{k}(end);

    fprintf('%s\n', 'Ok');

    if (~flip)
        StreamData.Fz_inner{k} = StreamData.Fz_inner{k}*-1;
    end
end

cd(pdir);   % return to original directory

end

    
