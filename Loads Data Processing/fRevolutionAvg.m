function RevData = fRevolutionAvg(SortedData)
% AVERAGES DATA INTO A SINGLE REVOLUTION
%
% INPUTS
%     SortedData
% OUTPUTS
%     RevData    -> structure with 1 cell per streaming data file
%                   cell contatining structures for each streaming data file variable
%                   RevData.var{k} = var over 1 revolution for StreamData.names{k}
%
%                     .avg_instRPM      -> 1 revoution of averaged data
%                                          (Naz points)
%                     .avg_Fx_outer     
%                     .avg_Fy_outer
%                     .avg_Fz_outer
%                     .avg_Mx_outer
%                     .avg_My_outer
%                     .avg_Mz_outer
%                     .avg_Fx_inner
%                     .avg_Fy_inner
%                     .avg_Fz_inner
%                     .avg_Mx_inner
%                     .avg_My_inner
%                     .avg_Mz_inner
%                     .avg_cts_outer
%                     .avg_cps_outer
%                     .avg_cts_inner
%                     .avg_cps_outer
%                     .avg_FM_outer 
%                     .avg_FM_inner
%                     .avg_FM_tot 
%
%                     .err_instRPM      -> standard deviation at a given
%                                          azimuth
%                     .err_Fx_outer     
%                     .err_Fy_outer
%                     .err_Fz_outer
%                     .err_Mx_outer
%                     .err_My_outer
%                     .err_Mz_outer
%                     .err_Fx_inner
%                     .err_Fy_inner
%                     .err_Fz_inner
%                     .err_Mx_inner
%                     .err_My_inner
%                     .err_Mz_inner
%                     .err_cts_outer
%                     .err_cps_outer
%                     .err_cts_inner
%                     .err_cps_outer
%                     .err_FM_outer 
%                     .err_FM_inner
%                     .err_FM_tot 
%
%                     .ms_instRPM      -> average over each revolution
%                                         (Nrev points)
%                     .ms_Fx_outer     
%                     .ms_Fy_outer
%                     .ms_Fz_outer
%                     .ms_Mx_outer
%                     .ms_My_outer
%                     .ms_Mz_outer
%                     .ms_Fx_inner
%                     .ms_Fy_inner
%                     .ms_Fz_inner
%                     .ms_Mx_inner
%                     .ms_My_inner
%                     .ms_Mz_inner
%                     .ms_cts_outer
%                     .ms_cps_outer
%                     .ms_cts_inner
%                     .ms_cps_outer
%                     .ms_FM_outer 
%                     .ms_FM_inner
%                     .ms_FM_tot 


fprintf('\n%s\n', 'Phase-averaging data');

for k = 1:length(SortedData.Fx_inner)
    fprintf('\t%s', ['- ' SortedData.names{k} ' ... ']);
    
    % average revolution 
    RevData.avg_check{k} = nanmean(SortedData.check{k});
    RevData.avg_instRPM{k} = nanmean(SortedData.instRPM{k});
    RevData.avg_Fx_outer{k} = nanmean(SortedData.Fx_outer{k});
    RevData.avg_Fy_outer{k} = nanmean(SortedData.Fy_outer{k});
    RevData.avg_Fz_outer{k} = nanmean(SortedData.Fz_outer{k});
    RevData.avg_Mx_outer{k} = nanmean(SortedData.Mx_outer{k});
    RevData.avg_My_outer{k} = nanmean(SortedData.My_outer{k});
    RevData.avg_Mz_outer{k} = nanmean(SortedData.Mz_outer{k});
    RevData.avg_Fx_inner{k} = nanmean(SortedData.Fx_inner{k});
    RevData.avg_Fy_inner{k} = nanmean(SortedData.Fy_inner{k});
    RevData.avg_Fz_inner{k} = nanmean(SortedData.Fz_inner{k});
    RevData.avg_Mx_inner{k} = nanmean(SortedData.Mx_inner{k});
    RevData.avg_My_inner{k} = nanmean(SortedData.My_inner{k});
    RevData.avg_Mz_inner{k} = nanmean(SortedData.Mz_inner{k});
    
    RevData.avg_ax{k} = nanmean(SortedData.ax{k});
    RevData.avg_ay{k} = nanmean(SortedData.ay{k});
    
    RevData.avg_cts_outer{k} = nanmean(SortedData.cts_outer{k});
    RevData.avg_cps_outer{k} = nanmean(SortedData.cps_outer{k});
    RevData.avg_cts_inner{k} = nanmean(SortedData.cts_inner{k});
    RevData.avg_cps_inner{k} = nanmean(SortedData.cps_inner{k});
    
    RevData.avg_FM_outer{k} = nanmean(SortedData.FM_outer{k});
    RevData.avg_FM_inner{k} = nanmean(SortedData.FM_inner{k});
    RevData.avg_FM_tot{k} = nanmean(SortedData.FM_tot{k});
   
    % standard deviation
    RevData.err_instRPM{k} = nanstd(SortedData.instRPM{k});
    RevData.err_Fx_outer{k} = nanstd(SortedData.Fx_outer{k});
    RevData.err_Fy_outer{k} = nanstd(SortedData.Fy_outer{k});
    RevData.err_Fz_outer{k} = nanstd(SortedData.Fz_outer{k});
    RevData.err_Mx_outer{k} = nanstd(SortedData.Mx_outer{k});
    RevData.err_My_outer{k} = nanstd(SortedData.My_outer{k});
    RevData.err_Mz_outer{k} = nanstd(SortedData.Mz_outer{k});
    RevData.err_Fx_inner{k} = nanstd(SortedData.Fx_inner{k});
    RevData.err_Fy_inner{k} = nanstd(SortedData.Fy_inner{k});
    RevData.err_Fz_inner{k} = nanstd(SortedData.Fz_inner{k});
    RevData.err_Mx_inner{k} = nanstd(SortedData.Mx_inner{k});
    RevData.err_My_inner{k} = nanstd(SortedData.My_inner{k});
    RevData.err_Mz_inner{k} = nanstd(SortedData.Mz_inner{k});
    
    RevData.err_ax{k} = nanstd(SortedData.ax{k});
    RevData.err_ay{k} = nanstd(SortedData.ay{k});
    
    RevData.err_cts_outer{k} = nanstd(SortedData.cts_outer{k});
    RevData.err_cps_outer{k} = nanstd(SortedData.cps_outer{k});
    RevData.err_cts_inner{k} = nanstd(SortedData.cts_inner{k});
    RevData.err_cps_inner{k} = nanstd(SortedData.cps_inner{k});

    RevData.err_FM_outer{k} = nanstd(SortedData.FM_outer{k});
    RevData.err_FM_inner{k} = nanstd(SortedData.FM_inner{k});
    RevData.err_FM_tot{k} = nanstd(SortedData.FM_tot{k});

    % average over each revolution
    RevData.ms_check{k} = nanmean(SortedData.check{k}');
    RevData.ms_instRPM{k} = nanmean(SortedData.instRPM{k}');
    RevData.ms_Fx_outer{k} = nanmean(SortedData.Fx_outer{k}');
    RevData.ms_Fy_outer{k} = nanmean(SortedData.Fy_outer{k}');
    RevData.ms_Fz_outer{k} = nanmean(SortedData.Fz_outer{k}');
    RevData.ms_Mx_outer{k} = nanmean(SortedData.Mx_outer{k}');
    RevData.ms_My_outer{k} = nanmean(SortedData.My_outer{k}');
    RevData.ms_Mz_outer{k} = nanmean(SortedData.Mz_outer{k}');
    RevData.ms_Fx_inner{k} = nanmean(SortedData.Fx_inner{k}');
    RevData.ms_Fy_inner{k} = nanmean(SortedData.Fy_inner{k}');
    RevData.ms_Fz_inner{k} = nanmean(SortedData.Fz_inner{k}');
    RevData.ms_Mx_inner{k} = nanmean(SortedData.Mx_inner{k}');
    RevData.ms_My_inner{k} = nanmean(SortedData.My_inner{k}');
    RevData.ms_Mz_inner{k} = nanmean(SortedData.Mz_inner{k}');
    
    RevData.ms_ax{k} = nanmean(SortedData.ax{k}');
    RevData.ms_ay{k} = nanmean(SortedData.ay{k}');
    
    RevData.ms_cts_outer{k} = nanmean(SortedData.cts_outer{k}');
    RevData.ms_cps_outer{k} = nanmean(SortedData.cps_outer{k}');
    RevData.ms_cts_inner{k} = nanmean(SortedData.cts_inner{k}');
    RevData.ms_cps_inner{k} = nanmean(SortedData.cps_inner{k}');
    
    RevData.ms_FM_outer{k} = nanmean(SortedData.FM_outer{k}');
    RevData.ms_FM_inner{k} = nanmean(SortedData.FM_inner{k}');
    RevData.ms_FM_tot{k} = nanmean(SortedData.FM_tot{k}');
    
    fprintf('%s\n', ' Ok');
end
