function [vortex_data] = fanalyze_vortex(vortex_data)

radius_threshold = 50; % units [mm]

% Computes the error ellipse for the scatter in vortex position for each
% azimuthal location. Data used is after erroneous data points computed
% from Gamma_1 method have been removed (See foutlierdetection.m)

% Loops over azimuthal locations    
for ii = 1:size(vortex_data.filtered,1) 
    
    % Loops over each vortex identified
    for jj = 1:size(vortex_data.filtered{ii,1},2) 
        
        X = [vortex_data.filtered{ii,1}{1,jj}(:,1),vortex_data.filtered{ii,1}{1,jj}(:,2)];
        [e]       = ferror_ellipse(X);       
        err(1,jj) = {e};
        
    end
    
    vortex_data.error_ellipse(ii,1) = {err};
    
end 

% Compute the average values for position (x,y), vortex core radius, and
% circulation, as well as the standard deviation with 95% confidence, for
% each vortex found at each azimuthal location

% Loops over azimuthal locations
for ii = 1:size(vortex_data.filtered,1) 
    
    % Loops over each vortex identified
    for jj = 1:size(vortex_data.filtered{ii,1},2) 
        
        var_x = vortex_data.filtered{ii,1}{1,jj}(:,1);
        var_y = vortex_data.filtered{ii,1}{1,jj}(:,2);
        var_r = vortex_data.filtered{ii,1}{1,jj}(:,3);
        var_c = vortex_data.filtered{ii,1}{1,jj}(:,4);
        
        % Compute average values
        x_avg = mean(var_x);
        y_avg = mean(var_y);
        
        delete_rows         = var_r > radius_threshold;
        var_r(delete_rows)  = nan;
        var_c(delete_rows)  = nan;
        rad_avg             = nanmean(var_r);
        circ_avg            = nanmean(var_c);
        
        % Compute standard deviation with 95% confidence
        p  = 0.95; 
        nu = size(var_x,1);
        xx = tinv(p,nu);
        
        x_std    = nanstd(var_x)*xx;
        y_std    = nanstd(var_y)*xx;
        rad_std  = nanstd(var_r)*xx;
        circ_std = nanstd(var_c)*xx;
        
        % Assemble avg's and std's into matrix 
        avg_matrix = [x_avg, y_avg, rad_avg, circ_avg];
        std_matrix = [x_std, y_std, rad_std, circ_std];
        
        avg(1,jj) = {avg_matrix};
        std(1,jj) = {std_matrix};
        
    end
    
    % Allocating data to structure
    vortex_data.avg.position(ii,1) = {avg};
    vortex_data.avg.std(ii,1)      = {std};
    
end

end