function [StreamData, SortedData] = SortStream(StreamData, conditions)
% INPUTS
%     StreamData
%     conditions = [Temperature [F], % Humidity, Prassure [in-hg]]
% OUTPUTS
%     StreamData -> adds caluclated variables to StreamData
%                     .sigma
%                     .rho
%                     .OMEGA
%                     .binsize
%     SortedData -> structure containing streaming data sorted into matrices;
%                   each cell = one mean data file; each row matrix = one revolution
%                   calculates ct/sigma,cp/sigma, and FM's
%                     .binsize      -> number of points recorded in each revolution
%                     .encoder      -> azimuthal position
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

StreamData.R = 1.108;
c = 0.08;
Nblade = 2;
StreamData.sigma = StreamData.R*c*Nblade / (pi*StreamData.R^2);

T = (conditions(1) - 32)*5/9 + 273.15; % [Kelvin]
humid = conditions(2);
P = conditions(3)*101325/29.9212; % [Pa]
R_air = 287.05; % INDIVIDUAL GAS CONSTANT
StreamData.rho = P/R_air/T;

SR = 10000; % SAMPLE RATE

% CALCULATE OMEGA FROM 1/Rev
for k = 1:length(StreamData.names)
    StreamData.binsize{k} = zeros(1,101);
    for n = 1:101
        StreamData.binsize{k}(n) = sum(StreamData.revolution{k}(:) == n-1);
        if StreamData.binsize{k}(n) > StreamData.binsize{k}(1) + 10 %CUT OFF REV WHERE ENCODER MISSED NEXT REV SIGNAL 
            StreamData.binsize{k}(n) = StreamData.binsize{k}(1) + 10;
        end
        
    end
    StreamData.OMEGA{k} = SR./StreamData.binsize{k} * 2 * pi;
    SortedData.binsize{k} = StreamData.binsize{k};
end

% CALCULATE CT/S AND CP/S
for k = 1:length(StreamData.names)
    count = 1;
    
    SortedData.check{k} = [];    
    SortedData.encoder{k} = [];
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

    SortedData.cts_outer{k} = [];
    SortedData.cps_outer{k} = [];
    SortedData.cts_inner{k} = [];
    SortedData.cps_inner{k} = [];
    
    SortedData.FM_outer{k} = [];
    SortedData.FM_inner{k} = [];
    SortedData.FM_tot{k} = [];
    
    bmax = max(SortedData.binsize{k});
    
    for n = 1:101
        b = SortedData.binsize{k}(n);
        % put in a place holder of -77 to pad the end of each revolution
        SortedData.check{k}(n,:) = [StreamData.revolution{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.encoder{k}(n,:) = [StreamData.encoder{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        az = StreamData.encoder{k}(count:count-1+b)';
        azdt = wshift('1D', az, 1);
        instRPM = (azdt(1:end-1) - az(1:end-1)) *SR * pi /180; % instantaneous RPM, rad/s
        SortedData.instRPM{k}(n,:) = [instRPM -77*ones(1,bmax-b+1)]; % add one element to get size 1xb        
        SortedData.Fx_outer{k}(n,:) = [StreamData.Fx_outer{k}(count:count-1+b)' -77*ones(1,bmax-b)];      
        SortedData.Fy_outer{k}(n,:) = [StreamData.Fy_outer{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.Fz_outer{k}(n,:) = [StreamData.Fz_outer{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.Mx_outer{k}(n,:) = [StreamData.Mx_outer{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.My_outer{k}(n,:) = [StreamData.My_outer{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.Mz_outer{k}(n,:) = [StreamData.Mz_outer{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.Fx_inner{k}(n,:) = [StreamData.Fx_inner{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.Fy_inner{k}(n,:) = [StreamData.Fy_inner{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.Fz_inner{k}(n,:) = [StreamData.Fz_inner{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.Mx_inner{k}(n,:) = [StreamData.Mx_inner{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.My_inner{k}(n,:) = [StreamData.My_inner{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        SortedData.Mz_inner{k}(n,:) = [StreamData.Mz_inner{k}(count:count-1+b)' -77*ones(1,bmax-b)];
        count = count+b;
    end
    
    SortedData.check{k}(SortedData.check{k} == -77) = nan;
    SortedData.encoder{k}(SortedData.encoder{k} == -77) = nan;
    SortedData.instRPM{k}(SortedData.instRPM{k} == -77) = nan;
    SortedData.Fx_outer{k}(SortedData.Fx_outer{k} == -77) = nan;
    SortedData.Fy_outer{k}(SortedData.Fy_outer{k} == -77) = nan;
    SortedData.Fz_outer{k}(SortedData.Fz_outer{k} == -77) = nan;
    SortedData.Mx_outer{k}(SortedData.Mx_outer{k} == -77) = nan;
    SortedData.My_outer{k}(SortedData.My_outer{k} == -77) = nan;
    SortedData.Mz_outer{k}(SortedData.Mz_outer{k} == -77) = nan;
    SortedData.Fx_inner{k}(SortedData.Fx_inner{k} == -77) = nan;
    SortedData.Fy_inner{k}(SortedData.Fy_inner{k} == -77) = nan;
    SortedData.Fz_inner{k}(SortedData.Fz_inner{k} == -77) = nan;
    SortedData.Mx_inner{k}(SortedData.Mx_inner{k} == -77) = nan;
    SortedData.My_inner{k}(SortedData.My_inner{k} == -77) = nan;
    SortedData.Mz_inner{k}(SortedData.Mz_inner{k} == -77) = nan;    
    
    OMEGA = StreamData.OMEGA{k};
    SortedData.cts_outer{k} = SortedData.Fz_outer{k} ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA'*StreamData.R).^2 / StreamData.sigma;
    SortedData.cps_outer{k} = SortedData.Mz_outer{k} ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA'*StreamData.R).^2 /StreamData.R / StreamData.sigma;
    SortedData.cts_inner{k} = SortedData.Fz_inner{k} ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA'*StreamData.R).^2 / StreamData.sigma;
    SortedData.cps_inner{k} = SortedData.Mz_inner{k} ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA'*StreamData.R).^2 /StreamData.R / StreamData.sigma;

    SortedData.cts_outer{k}(SortedData.cts_outer{k} == 0) = nan;
    SortedData.cps_outer{k}(SortedData.cps_outer{k} == 0) = nan;
    SortedData.cts_inner{k}(SortedData.cts_inner{k} == 0) = nan;
    SortedData.cps_inner{k}(SortedData.cps_inner{k} == 0) = nan;

%     RevData.FM_outer{k} = (abs(RevData.Fz_outer{k}).^(3/2)) ./ sqrt(2*StreamData.rho * pi*StreamData.R^2) ./ (OMEGA'.*RevData.Mz_outer{k});
%     RevData.FM_inner{k} = (abs(RevData.Fz_inner{k}).^(3/2)) ./ sqrt(2*StreamData.rho * pi*StreamData.R^2) ./ (OMEGA'.*RevData.Mz_inner{k});
%     RevData.FM_tot{k} = (abs(RevData.Fz_outer{k}).^(3/2) + abs(RevData.Fz_inner{k}).^(3/2)) ./ sqrt(2*StreamData.rho * pi*StreamData.R^2) ./ (OMEGA'.*RevData.Mz_outer{k} + OMEGA'.*RevData.Mz_inner{k});
    SortedData.FM_outer{k} = sqrt(StreamData.sigma) * (abs(SortedData.cts_outer{k}).^(3/2)) ./ sqrt(2)./ (SortedData.cps_outer{k});
    SortedData.FM_inner{k} = sqrt(StreamData.sigma) * (abs(SortedData.cts_inner{k}).^(3/2)) ./ sqrt(2)./ (SortedData.cps_inner{k});
    SortedData.FM_tot{k} = sqrt(StreamData.sigma) * ...
        (abs(SortedData.cts_outer{k} + SortedData.cts_inner{k}).^(3/2)) ./ sqrt(2)./ (SortedData.cps_outer{k} + SortedData.cps_inner{k});
    
    SortedData.FM_outer{k}(SortedData.FM_outer{k} == 0) = nan;
    SortedData.FM_inner{k}(SortedData.FM_inner{k} == 0) = nan;
    SortedData.FM_tot{k}(SortedData.FM_tot{k} == 0) = nan;

end


