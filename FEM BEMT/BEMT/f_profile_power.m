function [dCP0, CP0] = f_profile_power(R, r, dr, th, lam, sig, OMEGA, AF)

if strcmp(AF,'none')
    dCP0 = nan;
    CP0 = nan;
else
    for i = 1:length(r)
        % MACH NUMBER AT RADIAL LOCATION
        ut = OMEGA * r(i) * R;
        M = ut / 1125; % US UNITS
        
        % LOOK UP TABLES
        switch AF
            case 'VR12 Schmaus'
                Ms = [0.2, 0.4, 0.6, 0.8];
                [m,loc] = min(abs(Ms - M));
                M = Ms(loc);
                fieldname = ['M', num2str(M*10)];
                Cd_alpha = importdata('Cd_VR12_schmaus.mat');
                Cd_alpha = Cd_alpha.(fieldname);
            case 'VR12'
                Cd_alpha = importdata('Cd_VR12.mat');
            otherwise
                fprintf('Need AF Drag Table')
        end
        alpha = [min(Cd_alpha(:,1)):0.01:max(Cd_alpha(:,1))];
        Cds = interp1(Cd_alpha(:,1), Cd_alpha(:,2), alpha, 'pchip');
        
        % CD VALUE AT RADIAL LOCATION BASED ON ANGLE OF ATTACK
        a(i) = th(i) - lam(i)./r(i);
        [m,loc] = min(abs(alpha*pi./180 - a(i)));
        Cd(i) = Cds(loc);
    end
    
    % PROFILE POWER
    dCP0 = 1/2 *sig *Cd.* (r.^3)*dr;
    CP0 = sum(dCP0);
end
