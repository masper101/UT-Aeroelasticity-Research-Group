function [StreamData, SortedData] = fSortStream(StreamData)
% INPUTS
%     StreamData
%     conditions = [Temperature [F], % Humidity, Prassure [in-hg]]
% OUTPUTS
%     StreamData -> adds calculated variables to StreamData
%                     .sigma
%                     .rho
%                     .OMEGA
%                     .binsize
%     SortedData -> structure containing streaming data sorted into matrices;
%                   each cell = one mean data file; each row matrix = one revolution
%                   calculates ct/sigma,cp/sigma, and FM's
%                     .binsize      -> number of points recorded in each revolution
%                     .nrevs
%                     .names
%                     .check
%                     .encoder      -> azimuthal position
%                     .azimuth      -> vector of azimuths at which all data
%                                      is resampled
%                     .instRPM      -> instantaneous rotor speed at each time
%                     .Fx_outer     -> all data points recorded by labview
%                     .Fy_outer
%                     .Fz_outer
%                     .Mx_outer
%                     .My_outer
%                     .Mz_outer
%                     .Fx_inner
%                     .Fy_inner
%                     .Fz_inner
%                     .Mx_inner
%                     .My_inner
%                     .Mz_inner
%                     .cts_outer
%                     .cps_outer
%                     .cts_inner
%                     .cps_outer
%                     .FM_outer = (F)^1.5 / P / sqrt(2 rho A)
%                     .FM_inner
%                     .FM_tot = (F + F)^1.5 / (P+P) / sqrt(2 rho A)

%% DEFINE CONSTANTS
Nbits = 12;       % number of bits in the 
StreamData.R = 1.108;
c = 0.08;
Nblade = 2;
StreamData.sigma = StreamData.R*c*Nblade / (pi*StreamData.R^2);

SR = 10000; % SAMPLE RATE
Naz = 1000;   % dpsi = 0.36 deg
enc = input('\nEncoder? [Y/N] ','s');

%% CALCULATE OMEGA FROM 1/Rev
for k = 1:length(StreamData.names)
    StreamData.binsize{k} = zeros(1,StreamData.nrevs{k});
    for n = 1:StreamData.nrevs{k}
        StreamData.binsize{k}(n) = sum(StreamData.revolution{k}(:) == n-1);
        if StreamData.binsize{k}(n) > StreamData.binsize{k}(1) + 100 %CUT OFF REV WHERE ENCODER MISSED NEXT REV SIGNAL 
            StreamData.binsize{k}(n) = StreamData.binsize{k}(1);
        end
    end
    StreamData.OMEGA{k} = SR./StreamData.binsize{k} * 2 * pi;
    SortedData.binsize{k} = StreamData.binsize{k};
    SortedData.nrevs{k} = StreamData.nrevs{k};
    SortedData.names{k} = StreamData.names{k};
end

fprintf('\n%s\n', 'Sorting data');

%% CALCULATE CT/S AND CP/S
for k = 1:length(StreamData.names)
    
    fprintf('\t%s', ['- ' StreamData.names{k} ' ... ']);

    count = 1;
    RotorTurning = true;
    
    SortedData.check{k} = [];    
    SortedData.encoder{k} = [];
    SortedData.azimuth{k} = [];
    
    SortedData.instRPM{k} = [];    
    SortedData.Fx_outer{k} = [];
    SortedData.Fy_outer{k} = [];
    SortedData.Fz_outer{k} = []; 
    SortedData.Mx_outer{k} = [];
    SortedData.My_outer{k} = [];
    SortedData.Mz_outer{k} = [];
    SortedData.Fx_inner{k} = [];
    SortedData.Fy_inner{k} = [];
    SortedData.Fz_inner{k} = [];
    SortedData.Mx_inner{k} = [];
    SortedData.My_inner{k} = [];
    SortedData.Mz_inner{k} = [];

    SortedData.ax{k} = [];
    SortedData.ay{k} = [];
    
    SortedData.cts_outer{k} = [];
    SortedData.cps_outer{k} = [];
    SortedData.cts_inner{k} = [];
    SortedData.cps_inner{k} = [];
    
    SortedData.FM_outer{k} = [];
    SortedData.FM_inner{k} = [];
    SortedData.FM_tot{k} = [];
    
    SortedData.ctcp{k} = [];
    
    % if there is only one value in StreamData.encoder, it means that
    % the rotor is not turning,
    if length(unique(StreamData.encoder{k}))==1
        RotorTurning = false;
    end
    
    SortedData.azimuth{k} = linspace(0, 360*(1-1/Naz), Naz);
        
    for n = 1:StreamData.nrevs{k}
        b = SortedData.binsize{k}(n);
        
        SortedData.check{k}(n,1:b) = StreamData.revolution{k}(count:count-1+b)';

        % if the rotor is not turning no need to interpolate
        if RotorTurning
            if enc == 'Y'||enc == 'y'
                az = StreamData.encoder{k}(count:count-1+b)';
            else 
                az = [360/b:360/b:360];
%                 StreamData.encoder{k}(count:count-1+b) =[360/b:360/b:360]; 
            end
            
            % SortedData.encoder{k}(n,1:b) = StreamData.encoder{k}(count:count-1+b)';
            % if binsize is greater than maximum readable by encoder, decimate
            % the data stream by dcm8 = 3
            dcm8 = 3;
            if b > (2^Nbits-1)
                az = az(1:dcm8:end);     % length of decimated az is ceil(b/3);
                SortedData.encoder{k}(n,1:length(az)) = az;
                azdt = circshift(az,-1);
                instRPM = (azdt(1:end-1) - az(1:end-1)) *SR * pi /180 /dcm8; % instantaneous RPM, rad/s
                instRPM = [instRPM instRPM(end)]; % add one element to get size 1xb
                % interpolate to azimuth with dpsi = 1/Naz
                SortedData.instRPM{k}(n,:) = interp1(az, instRPM, SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fx_outer{k}(n,:) = interp1(az, StreamData.Fx_outer{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fy_outer{k}(n,:) = interp1(az, StreamData.Fy_outer{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fz_outer{k}(n,:) = interp1(az, StreamData.Fz_outer{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Mx_outer{k}(n,:) = interp1(az, StreamData.Mx_outer{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.My_outer{k}(n,:) = interp1(az, StreamData.My_outer{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Mz_outer{k}(n,:) = interp1(az, StreamData.Mz_outer{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fx_inner{k}(n,:) = interp1(az, StreamData.Fx_inner{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fy_inner{k}(n,:) = interp1(az, StreamData.Fy_inner{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fz_inner{k}(n,:) = interp1(az, StreamData.Fz_inner{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Mx_inner{k}(n,:) = interp1(az, StreamData.Mx_inner{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.My_inner{k}(n,:) = interp1(az, StreamData.My_inner{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Mz_inner{k}(n,:) = interp1(az, StreamData.Mz_inner{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.ax{k}(n,:) = interp1(az, StreamData.ax{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.ay{k}(n,:) = interp1(az, StreamData.ay{k}(count:dcm8:count-1+b)', SortedData.azimuth{k}, 'pchip');
            else
                SortedData.encoder{k}(n,1:b) = az;
                azdt = circshift(az,-1);
                instRPM = (azdt(1:end-1) - az(1:end-1)) *SR * pi /180; % instantaneous RPM, rad/s
                instRPM = [instRPM instRPM(end)]; % add one element to get size 1xb
                % interpolate to azimuth with dpsi = 1/Naz
                
                SortedData.instRPM{k}(n,:) = interp1(az, instRPM, SortedData.azimuth{k}, 'pchip');

                
                SortedData.Fx_outer{k}(n,:) = interp1(az, StreamData.Fx_outer{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fy_outer{k}(n,:) = interp1(az, StreamData.Fy_outer{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fz_outer{k}(n,:) = interp1(az, StreamData.Fz_outer{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Mx_outer{k}(n,:) = interp1(az, StreamData.Mx_outer{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.My_outer{k}(n,:) = interp1(az, StreamData.My_outer{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Mz_outer{k}(n,:) = interp1(az, StreamData.Mz_outer{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fx_inner{k}(n,:) = interp1(az, StreamData.Fx_inner{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fy_inner{k}(n,:) = interp1(az, StreamData.Fy_inner{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Fz_inner{k}(n,:) = interp1(az, StreamData.Fz_inner{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Mx_inner{k}(n,:) = interp1(az, StreamData.Mx_inner{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.My_inner{k}(n,:) = interp1(az, StreamData.My_inner{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.Mz_inner{k}(n,:) = interp1(az, StreamData.Mz_inner{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.ax{k}(n,:) = interp1(az, StreamData.ax{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
                
                SortedData.ay{k}(n,:) = interp1(az, StreamData.ay{k}(count:count-1+b)', SortedData.azimuth{k}, 'pchip');
            end
        else
            SortedData.azimuth{k} = 0:1/b*360:360*(1-1/b);
            SortedData.encoder{k}(n,1:b) = SortedData.azimuth{k};
            SortedData.instRPM{k}(n,:) = zeros(1,b);
            SortedData.Fx_outer{k}(n,:) = StreamData.Fx_outer{k}(count:count-1+b)';
            SortedData.Fy_outer{k}(n,:) = StreamData.Fy_outer{k}(count:count-1+b)';              
            SortedData.Fz_outer{k}(n,:) = StreamData.Fz_outer{k}(count:count-1+b)';                
            SortedData.Mx_outer{k}(n,:) = StreamData.Mx_outer{k}(count:count-1+b)';
            SortedData.My_outer{k}(n,:) = StreamData.My_outer{k}(count:count-1+b)';
            SortedData.Mz_outer{k}(n,:) = StreamData.Mz_outer{k}(count:count-1+b)';
            SortedData.Fx_inner{k}(n,:) = StreamData.Fx_inner{k}(count:count-1+b)';
            SortedData.Fy_inner{k}(n,:) = StreamData.Fy_inner{k}(count:count-1+b)';
            SortedData.Fz_inner{k}(n,:) = StreamData.Fz_inner{k}(count:count-1+b)';
            SortedData.Mx_inner{k}(n,:) = StreamData.Mx_inner{k}(count:count-1+b)';
            SortedData.My_inner{k}(n,:) = StreamData.My_inner{k}(count:count-1+b)';
            SortedData.Mz_inner{k}(n,:) = StreamData.Mz_inner{k}(count:count-1+b)';
            SortedData.ax{k}(n,:) = StreamData.ax{k}(count:count-1+b)';
            SortedData.ay{k}(n,:) = StreamData.ay{k}(count:count-1+b)';

        end
        
        count = count+b;
                
    end 
    
    OMEGA = StreamData.OMEGA{k};
    SortedData.cts_outer{k} = SortedData.Fz_outer{k} ./ StreamData.rho{k} / (pi * StreamData.R^2) ./ (OMEGA'*StreamData.R).^2 / StreamData.sigma;
    SortedData.cps_outer{k} = SortedData.Mz_outer{k} ./ StreamData.rho{k} / (pi * StreamData.R^2) ./ (OMEGA'*StreamData.R).^2 /StreamData.R / StreamData.sigma;
    SortedData.cts_inner{k} = SortedData.Fz_inner{k} ./ StreamData.rho{k} / (pi * StreamData.R^2) ./ (OMEGA'*StreamData.R).^2 / StreamData.sigma;
    SortedData.cps_inner{k} = SortedData.Mz_inner{k} ./ StreamData.rho{k} / (pi * StreamData.R^2) ./ (OMEGA'*StreamData.R).^2 /StreamData.R / StreamData.sigma;

    SortedData.FM_outer{k} = sqrt(StreamData.sigma) * (abs(SortedData.cts_outer{k}).^(3/2)) ./ sqrt(2)./ (SortedData.cps_outer{k});
    SortedData.FM_inner{k} = sqrt(StreamData.sigma) * (abs(SortedData.cts_inner{k}).^(3/2)) ./ sqrt(2)./ (SortedData.cps_inner{k});
    SortedData.FM_tot{k} = sqrt(StreamData.sigma) * ...
        (abs(SortedData.cts_outer{k} + SortedData.cts_inner{k}).^(3/2)) ./ sqrt(2)./ (SortedData.cps_outer{k} + SortedData.cps_inner{k});
    
    SortedData.ctcp{k} = (SortedData.cts_outer{k}+SortedData.cts_inner{k})./(SortedData.cps_outer{k}+SortedData.cps_inner{k});
    fprintf('%s\n', ['Nrevs: ' num2str(StreamData.nrevs{k}) '... Ok'] );
   
end
end


