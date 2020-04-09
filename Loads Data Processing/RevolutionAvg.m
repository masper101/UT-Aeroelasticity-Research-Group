function RevData = RevolutionAvg(SortedData,StreamData)
% AVERAGES DATA INTO A SINGLE REVOLUTION
%
% INPUTS
%     SortedData
% OUTPUTS
%     RevData    -> 1 cell per streaming data file
%                   cell contatining structures for each streaming data file variable
%                   RevData{k}.var = var over 1 revolution for StreamData.names{k}
%                     .avg_Fx_outer     -> 1 revoution of averaged data
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
%                     .err_Fx_outer     -> 95% confidence interval at given azimuthal location = stardard deviation * 1.96
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


for k = 1:length(SortedData.Fx_inner)
    OMEGA = nanmean(StreamData.OMEGA{k});
    ct_bias = 8 ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.sigma;
    cp_bias = 0.48 ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 /StreamData.R / StreamData.sigma;

    RevData{k}.avg_check = nanmean(SortedData.check{k});
    RevData{k}.avg_Fx_outer = nanmean(SortedData.Fx_outer{k});
    RevData{k}.avg_Fy_outer = nanmean(SortedData.Fy_outer{k});
    RevData{k}.avg_Fz_outer = nanmean(SortedData.Fz_outer{k});
    RevData{k}.avg_Mx_outer = nanmean(SortedData.Mx_outer{k});
    RevData{k}.avg_My_outer = nanmean(SortedData.My_outer{k});
    RevData{k}.avg_Mz_outer = nanmean(SortedData.Mz_outer{k});
    RevData{k}.avg_Fx_inner = nanmean(SortedData.Fx_inner{k});
    RevData{k}.avg_Fy_inner = nanmean(SortedData.Fy_inner{k});
    RevData{k}.avg_Fz_inner = nanmean(SortedData.Fz_inner{k});
    RevData{k}.avg_Mx_inner = nanmean(SortedData.Mx_inner{k});
    RevData{k}.avg_My_inner = nanmean(SortedData.My_inner{k});
    RevData{k}.avg_Mz_inner = nanmean(SortedData.Mz_inner{k});
    
    RevData{k}.avg_cts_outer = nanmean(SortedData.cts_outer{k});
    RevData{k}.avg_cps_outer = nanmean(SortedData.cps_outer{k});
    RevData{k}.avg_cts_inner = nanmean(SortedData.cts_inner{k});
    RevData{k}.avg_cps_inner = nanmean(SortedData.cps_inner{k});
    
    RevData{k}.avg_FM_outer = nanmean(SortedData.FM_outer{k});
    RevData{k}.avg_FM_inner = nanmean(SortedData.FM_inner{k});
    RevData{k}.avg_FM_tot = nanmean(SortedData.FM_tot{k});
   
    RevData{k}.err_Fx_outer = nanstd(SortedData.Fx_outer{k})*1.96;
    RevData{k}.err_Fy_outer = nanstd(SortedData.Fy_outer{k})*1.96;
    RevData{k}.err_Fz_outer = nanstd(SortedData.Fz_outer{k})*1.96;
    RevData{k}.err_Mx_outer = nanstd(SortedData.Mx_outer{k})*1.96;
    RevData{k}.err_My_outer = nanstd(SortedData.My_outer{k})*1.96;
    RevData{k}.err_Mz_outer = nanstd(SortedData.Mz_outer{k})*1.96;
    RevData{k}.err_Fx_inner = nanstd(SortedData.Fx_inner{k})*1.96;
    RevData{k}.err_Fy_inner = nanstd(SortedData.Fy_inner{k})*1.96;
    RevData{k}.err_Fz_inner = nanstd(SortedData.Fz_inner{k})*1.96;
    RevData{k}.err_Mx_inner = nanstd(SortedData.Mx_inner{k})*1.96;
    RevData{k}.err_My_inner = nanstd(SortedData.My_inner{k})*1.96;
    RevData{k}.err_Mz_inner = nanstd(SortedData.Mz_inner{k})*1.96;
    
    RevData{k}.err_cts_outer = nanstd(SortedData.cts_outer{k})*1.96;
    RevData{k}.err_cps_outer = nanstd(SortedData.cps_outer{k})*1.96;
    RevData{k}.err_cts_inner = nanstd(SortedData.cts_inner{k})*1.96;
    RevData{k}.err_cps_inner = nanstd(SortedData.cps_inner{k})*1.96;
  
    RevData{k}.toterr_cts_outer = sqrt(RevData{k}.err_cts_outer.^2 + ct_bias.^2);
    RevData{k}.toterr_cps_outer = sqrt(RevData{k}.err_cps_outer.^2 + cp_bias.^2);
    RevData{k}.toterr_cts_inner = sqrt(RevData{k}.err_cts_inner.^2 + ct_bias.^2);
    RevData{k}.toterr_cps_inner = sqrt(RevData{k}.err_cps_inner.^2 + cp_bias.^2);
    

    RevData{k}.err_FM_outer = nanstd(SortedData.FM_outer{k})*1.96;
    RevData{k}.err_FM_inner = nanstd(SortedData.FM_inner{k})*1.96;
    RevData{k}.err_FM_tot = nanstd(SortedData.FM_tot{k})*1.96;

end
