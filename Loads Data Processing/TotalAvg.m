function AvgData = TotalAvg(RevData,StreamData)
% CALULATES TOTAL AVERAGE AND ERROR FOR STREAM DATA FILE
%
%INPUTS
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
%                     .err_cts_outer = sqrt(precision^2 + bias^2)
%                     .err_cps_outer   bias from uncertatiny in load cell (8 N force, .48 N-m in moment; 
%                     .err_cps_outer   precision = sqrt(sum(errors from RevolutionData)^2))/N
%                     .err_cts_inner
%                     .err_cps_outer
%                     .err_FM_outer 
%                     .err_FM_inner
%                     .err_FM_tot 
for k = 1:length(RevData)
    AvgData.names{k} = StreamData.names{k};
    AvgData.avg_cts_outer{k} = nanmean(RevData{k}.avg_cts_outer);
    AvgData.avg_cps_outer{k} = nanmean(RevData{k}.avg_cps_outer);
    AvgData.avg_cts_inner{k} = nanmean(RevData{k}.avg_cts_inner);
    AvgData.avg_cps_inner{k} = nanmean(RevData{k}.avg_cps_inner);
    AvgData.avg_FM_outer{k} = nanmean(RevData{k}.avg_FM_outer);
    AvgData.avg_FM_inner{k} = nanmean(RevData{k}.avg_FM_inner);
    AvgData.avg_FM_tot{k} = nanmean(RevData{k}.avg_FM_tot);
   
    
    OMEGA = nanmean(StreamData.OMEGA{k});
    ct_bias = 8 ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 / StreamData.sigma;
    cp_bias = 0.48 ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA*StreamData.R).^2 /StreamData.R / StreamData.sigma;
    
%     cts_outer_prec = nanstd(PhaseAvgData{k}.avg_cts_outer)*1.96;
%     cps_outer_prec = nanstd(PhaseAvgData{k}.avg_cps_outer)*1.96;
%     cts_inner_prec = nanstd(PhaseAvgData{k}.avg_cts_inner)*1.96;
%     cps_inner_prec = nanstd(PhaseAvgData{k}.avg_cps_inner)*1.96;
    cts_outer_prec = sqrt(nansum(RevData{k}.err_cts_outer.^2))/length(RevData{k}.err_cts_outer);
    cps_outer_prec = sqrt(nansum(RevData{k}.err_cps_outer.^2))/length(RevData{k}.err_cps_outer);
    cts_inner_prec = sqrt(nansum(RevData{k}.err_cts_inner.^2))/length(RevData{k}.err_cts_inner);
    cps_inner_prec = sqrt(nansum(RevData{k}.err_cps_inner.^2))/length(RevData{k}.err_cps_inner);
    
    AvgData.err_cts_outer{k} = sqrt((cts_outer_prec).^2 + (ct_bias)^2);
    AvgData.err_cps_outer{k} = sqrt((cps_outer_prec).^2 + (cp_bias)^2);
    AvgData.err_cts_inner{k} = sqrt((cts_inner_prec).^2 + (ct_bias)^2);
    AvgData.err_cps_inner{k} = sqrt((cps_inner_prec).^2 + (cp_bias)^2);
    
    
%     AvgData.err_FM_outer{k} = nanstd(PhaseAvgData{k}.avg_FM_outer)*1.96;
%     AvgData.err_FM_inner{k} = nanstd(PhaseAvgData{k}.avg_FM_inner)*1.96;
%     AvgData.err_FM_tot{k} = nanstd(PhaseAvgData{k}.avg_FM_tot)*1.96;
    AvgData.err_FM_outer{k} = sqrt(nansum(RevData{k}.err_FM_outer.^2))/length(RevData{k}.err_FM_outer);
    AvgData.err_FM_inner{k} = sqrt(nansum(RevData{k}.err_FM_inner.^2))/length(RevData{k}.err_FM_inner);
    AvgData.err_FM_tot{k} = sqrt(nansum(RevData{k}.err_FM_tot.^2))/length(RevData{k}.err_FM_tot);

    
    AvgData.avg_cts_total{k} = (AvgData.avg_cts_inner{k} + AvgData.avg_cts_outer{k})/2;
    AvgData.avg_cps_total{k} = (AvgData.avg_cps_inner{k} + AvgData.avg_cps_outer{k})/2;
    
    AvgData.err_cts_total{k} = sqrt((AvgData.err_cts_inner{k}/2)^2 + (AvgData.err_cts_outer{k}/2)^2);
    AvgData.err_cps_total{k} = sqrt((AvgData.err_cps_inner{k}/2)^2 + (AvgData.err_cps_outer{k}/2)^2);
end


