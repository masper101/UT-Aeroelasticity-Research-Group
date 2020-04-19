function [vortex_data] = foutlierdetection(vortex_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function takes all of the instantaneous vortex positions, size, and
% circulation at certain azimuthal location and arranges them into one
% matrix. Groups or clusters of data are identified from all of the vortex
% center points. Each cluster represents all of the instantaneous points
% found for n*vortices. A outlier detecion algorithm is then used to 
% identify and remove any erroneous data points. This is performed for all 
% azimuthal locations.
%
% Created: Patrick Mortimer 03/2020
%
% INPUTS:
%        vortex_data (see fVortex_ID)        
%
% OUTPUTS: 
%        The following field is added to vortex_data
%        vortex_data
%           (1) filtered: n x 1 cell array (n = # of azimuthal locations)
%               containing contains all the data points for each vortex
%               found at each azimuthal location. Each cell contains m
%               cells (m = # of vortices in a given flowfield) each with 
%               w x 5 matrices (w = # of vortex locations remaining after
%               outlier detection). The five columns of each matrix are for
%               the following paramters
%                   (a) x-coordinate 
%                   (b) y-coordinate 
%                   (c) core radius 
%                   (d) circulation,
%                   (e) identifier for the flowfield the vortex data was
%                       extracted from. 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clustNo = 3;

for ii = 1:2:size(vortex_data.raw,1)
    
    % Organizes all vortez positions at current azimuthal location into one
    % matrix
    var = cat(1,vortex_data.raw{ii,:});
    
    % Identfies cluster of data points representing each vortex found in
    % the flowfield
    T = clusterdata(var(:,1:2),'Linkage','ward','SaveMemory','on','Maxclust',clustNo);
    
    % Loops through and separates each parameter into the cluster groups 
    % identified
    for cc = 1:max(T)
     
        xx{cc} = var(T == cc,1);
        yy{cc} = var(T == cc,2);
        rr{cc} = var(T == cc,3);
        gg{cc} = var(T == cc,4);
        nn{cc} = var(T == cc,5);
        
    end
    
    % Outlier detection and removal 
    for ff = 1:clustNo
                
        clearvars var2
            
        matrix(ff,1) = {cat(2,xx{1,ff},yy{1,ff},rr{1,ff},gg{1,ff},nn{1,ff})};
        var2         = [matrix{ff,1}(:,1),matrix{ff,1}(:,2),matrix{ff,1}(:,3),matrix{ff,1}(:,4),matrix{ff,1}(:,5)];
        var3         = rmoutliers(var2,'median');
        vortex(1,ff) = {var3};
            
    end
    % Allocating all data to structure
    vortex_data.filtered(ii,1) = {vortex};
    
end

end