function [vortex_data] = fVortexID(Data,Settings)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This funtion calls two other funtions: 
% (1) fVortexLocation_Gamma1
% (2) fVortexSize
% It will loop through all azimuthal locations and flowfields saved in 
% Data.phase_resolved (see fLoading_txtdata). The vortex data will then be 
% saved to the structure vortex_data.
%
% Created: Patrick Mortimer 03/2020
%
% INPUTS:
%        Data: (see fLoading_data)
%        Settings: see fVortexID_settings. Sets the required settings needed
%        to operating the vortex location and size algorithms. e.g. setting
%        threshold value for the Gamma1 criteria for core location. 
%     
% OUPUTS:
%        vortex_data = structure with the following fields.
%           (1) raw: Contains all information found for each instantaneous
%               vortex found from each flowfield at each azimuthal location
%               in cells. Each cell contains the following information:
%               (i)   vortex core x-coordinate
%               (ii)  vortex core y-coordinate
%               (iii) vortex core radius
%               (iv)  vortex strength (circulation)
%               (v)   index referencing the flowfield data was extracted
%                     from
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loops through rows (azimuthal locations)
for B = 1:2:max(size(Data.phase_resolved.vx,1))
    
    % Loops through columns (instantaneous flowfields)
    for A = 1:max(size(Data.phase_resolved.vx,2))
        
        % Displays current progress
        disp( [ 'Azimuthal Location:  ', num2str(B),'  |  ', 'Flowfield:  ' num2str(A) ] )
        
        % Vortex center finding algorithm 
        [VortexCenter] = fVortexLocation_Gamma1(Data,B,A,Settings);
        
        % If no vortex center could be found
        if VortexCenter == 0
            
            var2 = [0,0,0,0,A];
            vortex_data.raw(B,A) = {var2};
            
        else % If one or multiple vortex center locations identified
        
        % Allocating center data to variables    
        xLocation = VortexCenter(:,1);
        yLocation = VortexCenter(:,2);
        FlowNum   = VortexCenter(:,3); % Identifier for the specific flowfield
        [area, circulation, points] = fVortexSize_Gamma2(Data,B,A,Settings);
        
        % Displays the number of Gamma1 and Gamma2 points found
        disp(['IDvortex: found ' num2str(length(xLocation)) ' G1 peaks.' ])
        disp(['IDvortex: StDev of ' num2str(std(area)) ' found G2 peaks = ' num2str(length(area))])
        
        % Loops through rows (center points identified)    
        for ii = 1:length(xLocation)
            
            % Loops through rows (different clusters found through Gamma2
            % algorithm)
            for kk = 1:length(area)
                
                % Need more than 3 points found to identify vortex core
                if length(points{kk}(:,1)) < 3
                    
                    in(kk) = false;
                    
                else % Determines if the vortex center lies within cluster of points found
                    
                    edges  = boundary(points{kk}(:,1),points{kk}(:,2),0);
                    in(kk) = inpolygon(xLocation(ii),yLocation(ii),points{kk}(edges,1),points{kk}(edges,2)); % True if VortexLoc is inside area
                    
                end
                
                if in(kk)% If a vortex center could be matched to an area (cluster of points)
                    
                    radius(kk)   = sqrt(abs(area(kk)/pi));
                    vortex(ii,:) = [xLocation(ii), yLocation(ii), radius(kk), circulation(kk), FlowNum(ii)];
                    
        			if Settings.IDvortex.mute == false % Displays information about vortex found
                           
        				disp(['IDvortex: Found one vortex at (' num2str(xLocation(ii)) ';' num2str(yLocation(ii)) ') with area = ' ...
                            num2str(area(kk)) ' mm2 and circulation = ' num2str(circulation(kk)*1e-6) ' m2/s'])
                        
                        if kk~=1 
                            
                           disp('IDvortex: Found vortex not in the largest area found.')
        				   info.G1peakInLargestG2peak(ii) = false;
                           
                        else 
                            
        				   info.G1peakInLargestG2peak(ii) = true;
                           
                        end
                    
                    end  
                                        
                end 
                
            end
            
            % All 'in' are false, the location is not in one of the areas
            if ~any(in) 
                
                disp('IDvortex: A found vortex could not be matched to an area.')
                vortex(ii,:) = [xLocation(ii), yLocation(ii), NaN, NaN, FlowNum(ii)];
                
            end
           
        end 
        
        % Allocates data to structure
        vortex_data.raw(B,A) = {vortex};
        
        clc
        
        end
        
    end
        
end

% End of function

end