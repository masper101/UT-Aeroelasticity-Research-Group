function [area, circulation, points] = fVortexSize_Gamma2(Data,B,A,Settings)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function determines the vortex core boundary for every vortex in the
% flowfield. From the points collected from the detection algorithm, 
% circulation and core area are calculated. 
% 
% Based on the paper
% Combining PIV, POD and vortex identification algorithms for the study of
% unsteady turbulent swirling flows
% Laurent Graftieaux
% 
% Created: Patrick Mortimer 03/2020
% 
% INPUTS:
%        Data (see fLoading_data)
%        A = index for flowfield being analyzed
%        B = index for azimuthal location 
%        Settings (See fvortexID_settings)
%     
% OUTPUTS:
%        area = Calculated vortex core area [mm^2]
%        circulation = Calculated circulation for each vortex found [mm^2/s]
%        points = Cell array of all groups of points found in the
%        flowfield. These groups correspond to potential vortices. 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defines the region size
n    = 11;
side = (n-1)/2;

x  = Data.phase_resolved.x(1:round(length(Data.phase_resolved.x)/2),1);
y  = Data.phase_resolved.y;
Vx = Data.phase_resolved.vx{B,A}(:,1:round(length(Data.phase_resolved.x)/2));
Vy = Data.phase_resolved.vy{B,A}(:,1:round(length(Data.phase_resolved.x)/2));

Gamma2 = 0*Vx;
 
% Main algorithm to determine the the gamma 2 value
for p = (side+1):length(x)-(side+1)
        
    for s = (side+1):length(y)-(side+1)
            
        if ~(Vx(s,p) == 0 && Vy(s,p) == 0) % == 0 where ROI cropped
                
           CenterLocation = [x(p) y(s)];
           xcomps = [...
                    reshape(Vx(s-side:s+side,p-side:p-1),[],1);...
                    reshape(Vx(s-side:s+side,p+1:p+side),[],1);...
                    reshape(Vx(s-side:s-1,p),[],1);...
                    reshape(Vx(s+1:s+side,p),[],1)];
           ycomps = [...
                    reshape(Vy(s-side:s+side,p-side:p-1),[],1);...
                    reshape(Vy(s-side:s+side,p+1:p+side),[],1);...
                    reshape(Vy(s-side:s-1,p),[],1);...
                    reshape(Vy(s+1:s+side,p),[],1)];
           UP = [mean(xcomps) mean(ycomps)];
           
           m  = 1;
           G2 = zeros(1,(n*n)-1);
                
           for i = p-side:p+side
                    
               for j = s-side:s+side
                        
                   if ~(i == p && j == s)
                            
                      mLocation = [x(i) y(j)];
                      P = CenterLocation-mLocation;
                      U = [Vx(j,i) Vy(j,i)];
                      UMP = U-UP;
                      G2(m) = (P(1)*UMP(2)-P(2)*UMP(1)) / (norm(P)*norm(UMP));
                      G2(isnan(G2)) = [];
                      m = m+1;
                            
                   end
                        
               end
                    
           end
                
           Gamma2(s,p) = mean(G2);
                
        end
            
    end
        
end

% Calculating the vorticity field. Taking the curl of the velocity field
[yMesh, xMesh] = meshgrid(y,x);
yMesh          = yMesh';
xMesh          = xMesh';
[VortField,~]  = curl(xMesh,yMesh,Vx*1000,Vy*1000); % mm, mm, mm/s, mm/s

% Find maximum values of Gamma2 matrix (locations of vortex cores)
% Applies threshold    
threshold = Settings.IDvortex.SizeThreshold; % Find all Gamma2 > set threshold in fvortexID_settings:
vl = find(abs(Gamma2) > threshold);

% If the array of all possible valid points is empty, increase the region
% size by 2 on either side. This occures until n > 25, then no vortex was
% found
if isempty(vl)
        
    if Settings.IDvortex.quick == false
            
        n = n+2;
        disp(['IDvortexSize: Changed AA size to ' num2str(n) ' by ' num2str(n)])
           
        if n > 25
                
           disp('IDvortexSize: No Gamma2 found. No vortex found !!!')
           area = NaN;
           circulation = NaN;
           points{1} = NaN;
           done = true;
                
        end
            
    else % Quick mode: don't try other ROI sizes 
            
        disp('IDvortexSize: No Gamma2 found. No vortex found in quick mode.')
        area        = NaN;
        circulation = NaN;
        points{1}   = NaN;
        done        = true;
           
    end
    
else % if array containing valid Gamma2 values is not empty
    
    % Clusters the data by finding groups of adjacent points
    data        = [xMesh(vl) yMesh(vl) Gamma2(vl) VortField(vl)];
    links       = linkage(pdist(data(:,1:2)));
    cutoffvalue = 1.0*max([abs(max(diff(x))); abs(max(diff(y)))]); % Immediately adjacent points are grouped
    data(:,5)   = cluster(links,'cutoff',cutoffvalue,'criterion','distance');
    
    % Calculating the circulation and the vortex core area from the groups
    % of points
    for ClusterNo = unique(data(:,5))'
            
        dataset{ClusterNo} = data(data(:,5) == ClusterNo,1:2);
            
        dA = mean(diff(x))*mean(diff(y)); % Every point in the center of A dA
        area(ClusterNo) = dA*length(dataset{ClusterNo}); % Area calculation
            
        circulation(ClusterNo) = sum(sum(data(data(:,5) == ClusterNo,4).*dA)); % Circulation mm^2/s
        
        % Displays the number of points found within the area calculated
        if Settings.IDvortex.mute == false
                
           disp(['IDvortexSize: Found ' num2str(length(dataset{ClusterNo}(:,1))) ' points within ' num2str(area(ClusterNo)) 'mm^2.'])
            
        end
            
    end
    
    % Allocating the data to output variables
    [area, I]   = sort(area,'descend'); % Sorts the data; smallest vortex first 
    points      = dataset(I); 
    circulation = circulation(I);
        
end
 
% figure
% hold all; grid on; box on; 
% quiver(Data.phase_resolved.x, Data.phase_resolved.y, Data.phase_resolved.vx{B,A}, Data.phase_resolved.vy{B,A},5,'k')
% for i = 1:length(points)
% 
%     plot(points{1,i}(:,1),points{1,i}(:,2),'o')
% 
% end
% title(num2str(threshold))

% End of function

end