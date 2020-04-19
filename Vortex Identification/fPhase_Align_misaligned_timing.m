function [Data] = fPhase_Align_misaligned_timing(Data,delta_psi,DataFiles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function takes time-resolved data and organizes it by phase 
% (azimuthal locations). A phase-average and the standard deviation of the 
% average flow field(s) is then computed. 
% 
% Created: Patrick Mortimer 03/2020
% 
% INPUTS:
%        Data = Structure containing time-resolved data.(See fLoading_Data)       
%        delta_psi = # of images per revolution
%        DataFiles = Array containing indices of blade passages for each
%        revolution
%
% OUTPUTS:
%        Data = structure containing the following fields
%          (1) time_resolved = all time-resolved data (see fLoading_data)
%          (2) phase_resolved = structure containing the following fields
%              (a) x   = x-axis of vector fields 
%              (b) y   = y-axis of vector fields
%              (c) vx  = cell array of vector fields of x-component of velocity
%                  [# of azimuthal locations x total # of revolutions]
%              (d) vy  = cell array of vector fields of y-component of velocity
%                  [# of azimuthal locations x total # of revolutions]
%              (e) avg = Phase-averaged results  
%                  (i)   vx = cell array of vector fields of x-component of 
%                        velocity [# of azimuthal locations]
%                  (ii)  stdvx = cell array of std matrices of x-component
%                        of velocity. [# of azimuthal locations]
%                  (iii) vy = cell array of vector fields of y-component of 
%                        velocity [# of azimuthal locations]
%                  (iv)  stdvy = cell array of std matrices of y-component 
%                        of velocity. [# of azimuthal locations]
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop over datasets
for ii = 1:max(size(Data.time_resolved.vx,2))
    
    % Saves the flowfield coordinates to the phase_resolved structure
    Data.phase_resolved.x = Data.time_resolved.x;
    Data.phase_resolved.y = Data.time_resolved.y;
    
    % Loops over azimuthal locations
    for n = 1:delta_psi
        
        % Loops over array containing images with blade at psi = 0 deg
        for j = 1:length(DataFiles)
            
            % Extracts and arranges all flowfields
            var_vx(n,j,ii) = Data.time_resolved.vx(DataFiles(j)+(n-1),ii);
            var_vy(n,j,ii) = Data.time_resolved.vy(DataFiles(j)+(n-1),ii);
    
        end
        
    end
    
    % Reshapes all flowfields extracts into a 2D cell matrix 
    Data.phase_resolved.vx = reshape(permute(var_vx,[1,2,3]),size(var_vx,1),[]);
    Data.phase_resolved.vy = reshape(permute(var_vy,[1,2,3]),size(var_vy,1),[]);
    
    % Loops over rows (Azimuthal location)
    for gg = 1%:max(size(Data.phase_resolved.vx,1))                         
        
        % Determines the phase-averaged flowfield and standard deviation
        var1 = cat(3,Data.phase_resolved.vx{gg});
        Data.phase_resolved.avg.vx(gg,1) = {mean(var1,3)};
        
        var2 = cat(3,Data.phase_resolved.vy{gg});
        Data.phase_resolved.avg.vy(gg,1)    = {mean(var2,3)};
     
    end

end

% End of function

end