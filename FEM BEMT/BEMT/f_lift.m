function [Cl] = f_lift(Cla, th, lam, r, R, OMEGA, AF)

if strcmp(AF,'none')   % IF NOT GIVEN AN AIRFOIL FOR LOOKUP TABLE
    Cl = Cla .*(th - lam./r);
else    
    for i = 1:length(r)
        % MACH NUMBER AT RADIAL LOCATION
        ut = OMEGA * r(i) * R;
        M = ut / 340; % US UNITS
        
        % LOOKUP TABLES
        switch AF
            case 'NACA0012'
                Ms = [0.2, 0.4, 0.6, 0.8];
                [m,loc] = min(abs(Ms - M));
                M = Ms(loc);
                fieldname = ['M', num2str(M*10)];                
                Cl_alpha = importdata('Cl_NACA0012.mat');
                Cl_alpha = Cl_alpha.(fieldname);
                
            case 'VR12 Schmaus'
                Ms = [0.1, 0.2, 0.3, 0.4, 0.5];
                [m,loc] = min(abs(Ms - M));
                M = Ms(loc);
                fieldname = ['M', num2str(M*10)];                
                Cl_alpha = importdata('Cl_VR12_schmaus.mat');
                Cl_alpha = Cl_alpha.(fieldname);
                
            case 'VR12'
                Cl_alpha = importdata('Cl_VR12.mat');
                
            otherwise
                fprintf('Need AF Table')
        end
        alpha = [min(Cl_alpha(:,1)):0.01:max(Cl_alpha(:,1))];
        Cls = interp1(Cl_alpha(:,1), Cl_alpha(:,2), alpha, 'pchip');
        
        % CL BASED ON ANGLE OF ATTACK
        a(i) = th(i) - lam(i)./r(i);
        [m,loc] = min(abs(alpha*pi./180 - a(i)));
        Cl(i) = Cls(loc);
    end
end