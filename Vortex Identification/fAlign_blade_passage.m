function [DataFiles] = fAlign_blade_passage(Data,pnts,Vtip,dz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function extracts inflow data over each data set and uses it to
% determine blade passage to use to phase-align time-resolved data with
% poor timing signal. 
%
% Created: Patrick Mortimer 04/2020
%
% INPUTS:
%        Data = Structure containing time-resolved data (see fLoading_Data)
%        points = Points define both ends of the blade in the ROI. Needed
%        for data extraction along the rotor blade
%        Vtip = Tip speed [m/s]
%
%        Additional inputs are coded into the function and can be changed 
%        as needed
%        rloc = Radial location used to extract inflow velocity 
%        pkthreshold = Threshold value needed to identify peaks indicating
%        blade passage
%
% OUTPUTS:
%        DataFiles = Array containing the flowfield where the blade is
%        crossing the measurement plane. One array per dataset. 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
rloc = 40; % Radial location to extract inflow data used to determine blade passages
pkthreshold = 0.02; % Sets threshold value for peak identification

% Distance above and below rotor blade to extract velocity data
points  = reshape(pnts,[2,2]);
 
% Plot flowfield with points needed for data extraction
figure
hold all; grid on; box on; 
quiver(Data.time_resolved.x,Data.time_resolved.y,Data.time_resolved.vx{1,1},Data.time_resolved.vy{1,1},5,'k')
plot(points(1,1),points(1,2),'ro')
plot(points(2,1),points(2,2),'ro')
 
% Loops over columns (Datasets)
for B = 2 %1:max(size(Data.time_resolved.vx,2))
    
    % Loops over rows (Instantaneous flowfields)
    for A = 1:max(size(Data.time_resolved.vx,1))
        
        % Function for extracting / interpolating inflow
        [vx,~,~,~] = fExtract_Inflow(Data,pnts,A,B,dz);     
        lambda_i(A,:)    = (vx./Vtip); % Axial velocity at rotor blade normalized by tip speed
    
    end
    
    [pks,locs] = findpeaks(lambda_i(:,rloc),'MinPeakProminence',pkthreshold); % Find peaks corresponding to blade passage and associated flowfield
    DataFiles(:,B) = {locs(1:2:end,1)}; % Takes every other peak found
    
end

% Plots results for quality check
figure 
hold all; grid on; box on;
plot(lambda_i(:,rloc),'k')
plot(locs,pks,'ro')

% End of function

end
