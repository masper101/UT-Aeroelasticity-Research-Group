function [Data] = fPhase_Align(Data,delta_psi,phaseshift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function takes time-resolved data and organizes it by phase 
% (azimuthal locations). A phase-average and the standard deviation of the 
% average flow field(s) is then computed. 
% 
% Created: Patrick Mortimer 03/2020
% 
% INPUTS:
%        Data = Structure containing time-resolved data.(See fLoading_Data)
%        delta_psi = Number of images per revolution (Azimuthal locations)
%        phaseshift = Number of images needed to reorganize phase-aligned
%        data such that psi_b = 0 deg appears first. 
% 
% OUPUTS:
%        Data = structure containing the following fields
%          (1)time_resolved = all time-resolved data (see fLoading_data)
%          (2)phase_resolved = structure containing the following fields
%             (a) x   = x-axis of vector fields 
%             (b) y   = y-axis of vector fields
%             (c) vx  = cell array of vector fields of x-component of velocity
%                 [# of azimuthal locations x total # of revolutions]
%             (d) vy  = cell array of vector fields of y-component of velocity
%                 [# of azimuthal locations x total # of revolutions]
%             (e) avg = Phase-averaged results  
%                 (i)   vx = cell array of vector fields of x-component of velocity
%                       [# of azimuthal locations]
%                 (ii)  stdvx = cell array of std matrices of x-component of
%                       velocity. [# of azimuthal locations]
%                 (iii) vy = cell array of vector fields of y-component of velocity
%                       [# of azimuthal locations]
%                 (iv)  stdvy = cell array of std matrices of y-component of
%                       velocity. [# of azimuthal locations]
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
% Determines the total number of revolutions in a dataset 
revs = max(size(Data.time_resolved.vx,1))/delta_psi; 
revs = round(revs);

% Saving the x and y - axis  
Data.phase_resolved.x = Data.time_resolved.x;
Data.phase_resolved.y = Data.time_resolved.y;

% Phase-aligning the time-resolved data
for kk = 1:max(size(Data.time_resolved.vx,2))
    
    % Reshaping the time-resolved vectors based on total number of revs 
    % and the number if images per revolution (delta_psi)
    var_vx(kk,1) = {reshape(Data.time_resolved.vx(:,kk),[delta_psi,revs])};  
    var_vy(kk,1) = {reshape(Data.time_resolved.vy(:,kk),[delta_psi,revs])};
        
end 

% Grouping all datasets into one cell array
Data.phase_resolved.vx = cat(2,var_vx{:});
Data.phase_resolved.vy = cat(2,var_vy{:});

% Pre-allocating intermediate variables
var1 = zeros(length(Data.phase_resolved.y),length(Data.phase_resolved.x),max(size(Data.phase_resolved.vx,1)));
var3 = zeros(length(Data.phase_resolved.y),length(Data.phase_resolved.x),max(size(Data.phase_resolved.vy,1)));

% Phase-averaging data
for  gg = 1:max(size(Data.phase_resolved.vx,1))                            % Loops over rows (Azimuthal location)
    
    for kk = 1:max(size(Data.phase_resolved.vx,2))                         % Loops over columns (Images or individual flow fields)
        
        var1(:,:,kk)               = cell2mat(Data.phase_resolved.vx(gg,kk));
        var2(gg,1)                 = {mean(var1,3)};
        Data.phase_resolved.avg.vx = circshift(var2,phaseshift,1);         % Reorganizes array so that psi_b = 0 deg is first flow field 
                                                                           % Needed if images do not start at psi_b = 0 deg                                                        
        Data.phase_resolved.avg.stdvx(gg,1) = {std(double(var1),[],3)};
        
        var3(:,:,kk)               = cell2mat(Data.phase_resolved.vy(gg,kk));
        var4(gg,1)                 = {mean(var3,3)};
        Data.phase_resolved.avg.vy = circshift(var4,phaseshift,1);         % Reorganizes array so that psi_b = 0 deg is first flow field 
                                                                           % Needed if images do not start at psi_b = 0 deg    
        Data.phase_resolved.avg.stdvy(gg,1) = {std(double(var3),[],3)};    
    
    end
        
end

% End of function

end 