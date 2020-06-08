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
%                     .avg_FM_tot 
%                     .err_cts_outer = sqrt(std(means)^2 + bias^2)/
%                                      sqrt(Nrev)
%                     .err_cps_outer   bias from uncertainty in load cell (8 N force, .48 N-m in moment; 
%                     .err_cts_inner
%                     .err_cps_outer
%                     .err_FM_outer 
%                     .err_FM_inner
%                     .err_FM_tot 

for k = 1:length(RevData)
    OMEGA = nanmean(StreamData.OMEGA{k});

    % non-dimensionalization factor for CT
    ct_den = StreamData.rho * (pi * StreamData.R^2) * (OMEGA*StreamData.R).^2;

    % non-dimensionalization factor for CP
    cq_den = StreamData.rho * (pi * StreamData.R^2) * (OMEGA*StreamData.R).^2 * StreamData.R;

    AvgData.names{k} = StreamData.names{k};
    AvgData.avg_cts_outer{k} = nanmean(RevData.avg_cts_outer{k});
    AvgData.avg_cps_outer{k} = nanmean(RevData.avg_cps_outer{k});
    AvgData.avg_cts_inner{k} = nanmean(RevData.avg_cts_inner{k});
    AvgData.avg_cps_inner{k} = nanmean(RevData.avg_cps_inner{k});
    AvgData.avg_FM_outer{k} = nanmean(RevData.avg_FM_outer{k});
    AvgData.avg_FM_inner{k} = nanmean(RevData.avg_FM_inner{k});
    AvgData.avg_FM_tot{k} = nanmean(RevData.avg_FM_tot{k});
   
    
    cts_bias = 8 / ct_den / StreamData.sigma;
    cps_bias = 0.48 / cq_den / StreamData.sigma;
    
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
 
    AvgData.avg_cts_total{k} = (AvgData.avg_cts_inner{k} + AvgData.avg_cts_outer{k})/2;
    AvgData.avg_cps_total{k} = (AvgData.avg_cps_inner{k} + AvgData.avg_cps_outer{k})/2;
       
    AvgData.err_cts_total{k} = 1.96* sqrt( std(RevData.ms_cts_outer{k}+RevData.ms_cts_inner{k})^2 ...
    + (2*cts_bias)^2 ) / sqrt(SortedData.nrevs{k}); 
    
    AvgData.err_cps_total{k} = 1.96* sqrt( std(RevData.ms_cps_outer{k}+RevData.ms_cps_inner{k})^2 ...
    + (2*cps_bias)^2 ) / sqrt(SortedData.nrevs{k}); 
end


