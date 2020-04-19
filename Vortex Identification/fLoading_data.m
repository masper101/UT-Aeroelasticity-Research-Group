function [Data] = fLoading_Data(D)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function loads PIV vector fields. Loops through all subfolders
% within main folder path. 
%
% Created: Patrick Mortimer 03/2020
%
% INPUTS:
%        D = 'main folder file path'
%
% OUTPUTS:
%        Data = structure containing the following fields
%          (1)time_resolved
%             (i)   x = x-axis of vector field 
%             (ii)  y = y-axis of vector field 
%             (iii) vx = vector field of x-component of velocity
%                   [# of vector fields x # of datasets]
%             (iv)  vy = vector field of y-component of velocity
%                   [# of vector fields x # of datasets] 
% 
% NOTE: This can be used to load existing phase-resolved data as well
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S = dir( fullfile( D, '*' ) ); % Sets directiry of main folder
N = setdiff({S([S.isdir]).name},{'.','..'}); % List of all subfolders

% Loops through subfolders
for ii = 1:numel(N)
    
    T = dir(fullfile(D,N{ii},'*')); % Sets directory for subfolders
    C = {T(~[T.isdir]).name}; % Files within subfolders
    
    % Loops through files
    for jj = 1:length(C)
        
        % Displays current status 
        disp(['Loading Folder:  ', num2str(ii),'  |  ', 'File:  ' num2str(jj)])
        
        data = importdata(fullfile(D,N{ii},C{jj}));
        
        % Organizes the data into flowfield matrix
        [x,~] = unique(data.data(:,1), 'rows');
        x = (x);
        [y,~] = unique(data.data(:,2), 'rows');
        y = flip(y);
        vx = reshape(data.data(:,3),[length(x),length(y)])';
        vy = reshape(data.data(:,4),[length(x),length(y)])';
        
        % Allocates organized data to structure
        Data.time_resolved.x = x;
        Data.time_resolved.y = y;
        Data.time_resolved.vx(jj,ii) = {vx};                                                
        Data.time_resolved.vy(jj,ii) = {-1*vy};                            
       
        clc
    
    end
    
end

disp('Loading Data Completed!!')

% End of function

end 