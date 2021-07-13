function AvgData = fTotalAvg(RevData,SortedData,StreamData)
% CALCULATES TOTAL AVERAGE AND ERROR FOR STREAM DATA FILE
%
% INPUTS
%     RevData
%     StreamData
% OUTPUTS
%     AvgData      -> structure containting total average of nondimensional var in each streaming data file ( 1 value per file )
%                     .names            -> streaming data file names
%                     .avg_cts_outer    -> total average
%                     .avg_cps_outer
%                     .avg_cts_inner
%                     .avg_cps_outer
%                     .avg_FM_outer 
%                     .avg_FM_inner

%                     .err_cts_outer = sqrt(std(means)^2 + bias^2)/
%                                      sqrt(Nrev)
%                     .err_cps_outer   bias from uncertainty in load cell (8 N force, .48 N-m in moment; 
%                     .err_cts_inner
%                     .err_cps_outer
%                     .err_FM_outer 
%                     .err_FM_inner
%                     .err_instRPM 
%                     .err_ms_instRPM 
%                     .err_curr1 
%                     .err_curr2 
%                     .err_ms_curr1 
%                     .err_ms_curr2 
%                     .err_Ttot (error of the azimuthal position mean)
%                     .err_Qtot 
%                     .err_Ptot
%                     .err_ms_Ttot (error of the revolution mean)
%                     .err_ms_Qtot 
%                     .err_ms_Ptot 

fprintf('\n%s\n', 'Averaging data');

for k = 1:length(StreamData.names)
    fprintf('\t%s', ['- ' SortedData.names{k} ' ... ']);
    
    OMEGA = nanmean(StreamData.OMEGA{k});

    % non-dimensionalization factor for CT
    ct_den = StreamData.rho{k} * (pi * StreamData.R^2) * (OMEGA*StreamData.R).^2;

    % non-dimensionalization factor for CP
    cq_den = StreamData.rho{k} * (pi * StreamData.R^2) * (OMEGA*StreamData.R).^2 * StreamData.R;

    AvgData.names{k} = StreamData.names{k};
    AvgData.avg_cts_outer{k} = nanmean(RevData.avg_cts_outer{k});
    AvgData.avg_cps_outer{k} = nanmean(RevData.avg_cps_outer{k});
    AvgData.avg_cts_inner{k} = nanmean(RevData.avg_cts_inner{k});
    AvgData.avg_cps_inner{k} = nanmean(RevData.avg_cps_inner{k});
    AvgData.avg_FM_outer{k} = nanmean(RevData.avg_FM_outer{k});
    AvgData.avg_FM_inner{k} = nanmean(RevData.avg_FM_inner{k});
    AvgData.avg_FM_tot{k} = nanmean(RevData.avg_FM_tot{k});
    AvgData.avg_ctcp{k} = nanmean(RevData.avg_ctcp{k}); 
    
    cts_bias = 8 / ct_den / StreamData.sigma; F_b = 8;
    cps_bias = 0.48 / cq_den / StreamData.sigma; M_b = 4.8;
    curr_b = 1.5; % 1% of F.S. (Amps)
    
    % standard error of the mean
    % se = std(means)/sqrt(Nrev)
    % multiply by 1.96 to get 95% CI
    AvgData.err_cts_outer{k} = 1.96* sqrt( std(RevData.ms_cts_outer{k})^2 + cts_bias^2 )...
        / sqrt(SortedData.nrevs{k});
    AvgData.err_cps_outer{k} = 1.96* sqrt( std(RevData.ms_cps_outer{k})^2 + cps_bias^2 )...
        / sqrt(SortedData.nrevs{k});
    AvgData.err_cts_inner{k} = 1.96* sqrt( std(RevData.ms_cts_inner{k})^2 + cts_bias^2 )...
        / sqrt(SortedData.nrevs{k});
    AvgData.err_cps_inner{k} = 1.96* sqrt( std(RevData.ms_cps_inner{k})^2 + cps_bias^2 )...
        / sqrt(SortedData.nrevs{k});

    AvgData.err_FM_outer{k} = 1.96* std(RevData.ms_FM_outer{k})/sqrt(SortedData.nrevs{k});
    AvgData.err_FM_inner{k} = 1.96* std(RevData.ms_FM_inner{k})/sqrt(SortedData.nrevs{k});
    AvgData.err_FM_tot{k} = 1.96* std(RevData.ms_FM_tot{k})/sqrt(SortedData.nrevs{k});
    
    AvgData.err_ctcp{k} = 1.96* std(RevData.ms_ctcp{k})/sqrt(SortedData.nrevs{k});
 
    AvgData.avg_cts_total{k} = (AvgData.avg_cts_inner{k} + AvgData.avg_cts_outer{k})/2;
    AvgData.avg_cps_total{k} = (AvgData.avg_cps_inner{k} + AvgData.avg_cps_outer{k})/2;
       
    AvgData.err_cts_total{k} = 1.96* sqrt( std(RevData.ms_cts_outer{k}+RevData.ms_cts_inner{k})^2 ...
    + (2*cts_bias)^2 ) / sqrt(SortedData.nrevs{k}); 
    
    AvgData.err_cps_total{k} = 1.96* sqrt( std(RevData.ms_cps_outer{k}+RevData.ms_cps_inner{k})^2 ...
    + (2*cps_bias)^2 ) / sqrt(SortedData.nrevs{k});

    % total mean (take the mean of all the means for each revolution throughout the
    % stream)
    AvgData.instRPM{k} = mean(RevData.ms_instRPM{k}); %[rpm]

    AvgData.curr1{k} = mean(RevData.ms_curr1{k});

    AvgData.curr2{k} = mean(RevData.ms_curr2{k});
    
    AvgData.Ttot{k} = mean(RevData.ms_Ttot{k});

    AvgData.Qtot{k} = mean(RevData.ms_Qtot{k});
    
    AvgData.Ptot{k} = mean(RevData.ms_Ptot{k});
    
    
    % total error (take the error of each entire revolution throughout the
    % stream)
    AvgData.err_instRPM{k} = 1.96* std(RevData.ms_instRPM{k})/sqrt(SortedData.nrevs{k});
    
    AvgData.err_curr1{k} = 1.96* sqrt(std(RevData.ms_curr1{k})^2 + curr_b^2)/sqrt(SortedData.nrevs{k});

    AvgData.err_curr2{k} = 1.96* sqrt(std(RevData.ms_curr2{k})^2 + curr_b^2)/sqrt(SortedData.nrevs{k});
    
    AvgData.err_Ttot{k} = 1.96* (sqrt(std(RevData.ms_Fz_outer{k})^2 + F_b^2) + ...
        sqrt(std(RevData.ms_Fz_inner{k})^2 + F_b^2))/sqrt(SortedData.nrevs{k});

    AvgData.err_Qtot{k} = 1.96* (sqrt(std(RevData.ms_Mz_outer{k})^2 + M_b^2) + ...
        sqrt(std(RevData.ms_Mz_inner{k})^2 + M_b^2))/sqrt(SortedData.nrevs{k});
    
    AvgData.err_Ptot{k} = sqrt((AvgData.err_Qtot{k}*AvgData.instRPM{k}*2*pi/60)^2 + ...
        (AvgData.Qtot{k}*AvgData.err_instRPM{k}*2*pi/60)^2);
    
    

    fprintf('%s\n', ' Ok');
end


