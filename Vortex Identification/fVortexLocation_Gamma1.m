function [VortexCenter] = fVortexLocation_Gamma1(Data,B,A,Settings)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This functin detects a single or multiple vortex location(s) in Vx and Vy 
% instantaneous velocity fields
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
%        VortexCenter = contains (x,y) coordinates of the vortex core
%        location
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defines the region size
n = 11;
side = (n-1)/2; 

% Allocates the data from the flowfield to variables
x  = Data.phase_resolved.x(1:round(length(Data.phase_resolved.x)/2),1);
y  = Data.phase_resolved.y;
Vx = Data.phase_resolved.vx{B,A}(:,1:round(length(Data.phase_resolved.x)/2));
Vy = Data.phase_resolved.vy{B,A}(:,1:round(length(Data.phase_resolved.x)/2));

% Preallocates the Gamma1 matrix
Gamma1 = 0*Vx;

% Main algorithm to determine the the gamma 1 value
for p = (side+1):length(x)-(side+1)
        
    for s = (side+1):length(y)-(side+1)
        
        if ~(Vx(s,p) == 0 && Vy(s,p) == 0 )
            
            CenterLocation = [x(p) y(s)];
            m = 1;
            G1 = zeros(1,(n*n)-1);
            
            for i = p-side:p+side
            
                for j = s-side:s+side
                    
                    if ~(i == p && j == s)
                        
                        mLocation = [x(i) y(j)];
                        P = CenterLocation - mLocation;
                        U = [Vx(j,i) Vy(j,i)];  
                        G1(m) = (P(1)*U(2)-P(2)*U(1))/(norm(P)*norm(U));
                        m = m+1;
                        
                    end 
                
                end 
            
            end
            
            G1(G1 == 0) = NaN;
            Gamma1(s,p) = nanmean(G1);
            
        end 
        
    end 
   
end 

% Find maximum values of Gamma1 matrix (locations of vortex cores)
% Applies threshold
a = max(max(Gamma1));
t = Settings.IDvortex.LocThreshold;
[row,column] = find(abs(Gamma1) > t);

for i = 1:length(row)
    
    a(i,1) = abs(Gamma1(row(i),column(i)));
    
end 

% If no value was found with current threshold value, decrease by 0.05 and
% run again. If no value was found decrease again.
if isempty([row,column])
    
   disp(['IDvortexLoc: No Gamma1>' num2str(t) ' found. Trying Gamma1>' num2str(t-0.05)])
   t = t-0.05;
   [row,column] = find(abs(Gamma1) > t);
   
   if isempty([row,column])
       
      disp(['IDvortexLoc: No Gamma1>' num2str(t) ' found. Trying Gamma1>' num2str(t-0.05)])
      t = t-0.05;
      [row,column] = find(abs(Gamma1) > t);
      
   end
   
end

% If after decreasing the threshold value doesn't work and quick mode is
% set to false in Settings, increase the region size. 
if isempty([row,column])
    
   if Settings.IDvortex.quick == false
       
      n = n+2;
      disp(['IDvortexLoc: Changed ij size to ' num2str(n) ' by ' num2str(n)])
      
   if n > 25
       
      disp(['IDvortexLoc: No Gamma1 values > ' num2str(t) '. No vortex found.'])
      xLoc = NaN;
      yLoc = NaN;
      done = true;
      
   end
   
   else % quick mode: don't try other i,j sizes
       
        disp(['IDvortexLoc: No Gamma1 values > ' num2str(t) '. No vortex found in quick mode.'])
        xLoc = NaN;
        yLoc = NaN;
        done = true;
        
   end
   
end 

% If not vortex is identified, set location to [0,0]
if a < Settings.IDvortex.LocThreshold
    
   Gamma1 = [];
   VortexCenter = [0,0];
   
end 

% When a vortex core is identified
if a > Settings.IDvortex.LocThreshold
   
   % Find the center coordinates based on the values found from the
   % identification algorithm
   VC = [Data.phase_resolved.x(column(:,1),1),Data.phase_resolved.y(row(:,1),1)];
    
   % If only 1 core location is identified
   if size(a,1) == 1 
   
       VortexCenter = [VC(1,1), VC(1,2), A];
   
   else % If multiple core locations are identified
       
       % Identifies specific groups out of the locations found 
       clustNo = 3; % Sets the total number of expected vortices
       T = clusterdata(VC(:,1:2),'Linkage','ward','SaveMemory','on','Maxclust',clustNo);
       
       % Organizes the locations based on the determined groups and finds
       % calculates an average if multiple values for one vortex has been
       % identified
       for ii = 1:max(T)
   
           varx(:,ii) = {VC(T == ii,1)};
           vary(:,ii) = {VC(T == ii,2)};
       
           avgx(ii,1) = mean(varx{:,ii});
           avgy(ii,1) = mean(vary{:,ii});
       
           flow_num(ii,1) = A;
       
       end
       
       VortexCenter = [avgx, avgy, flow_num];

   end
   
end

end