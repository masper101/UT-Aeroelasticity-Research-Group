function [SortedData, RevData] = fCheckCorrelation(SortedData, RevData)

% calculates cross-correlation of each revolution (Fz_inner and Fz_outer)
% with the mean over all revolutions

threshold = 0.95;     % how different the revolutions can be

for k = 1:length(SortedData.names)

    for rev = 1:SortedData.nrevs{k}
        crFxo(rev) = xcorr(SortedData.Fx_outer{k}(rev,:), RevData{k}.avg_Fx_outer, 0, 'coeff');
        crFyo(rev) = xcorr(SortedData.Fy_outer{k}(rev,:), RevData{k}.avg_Fy_outer, 0, 'coeff');
        crFzo(rev) = xcorr(SortedData.Fz_outer{k}(rev,:), RevData{k}.avg_Fz_outer, 0, 'coeff');
        crMxo(rev) = xcorr(SortedData.Mx_outer{k}(rev,:), RevData{k}.avg_Mx_outer, 0, 'coeff');
        crMyo(rev) = xcorr(SortedData.My_outer{k}(rev,:), RevData{k}.avg_My_outer, 0, 'coeff');
        crMzo(rev) = xcorr(SortedData.Mz_outer{k}(rev,:), RevData{k}.avg_Mz_outer, 0, 'coeff');
        
        crFxi(rev) = xcorr(SortedData.Fx_inner{k}(rev,:), RevData{k}.avg_Fx_inner, 0, 'coeff');
        crFyi(rev) = xcorr(SortedData.Fy_inner{k}(rev,:), RevData{k}.avg_Fy_inner, 0, 'coeff');
        crFzi(rev) = xcorr(SortedData.Fz_inner{k}(rev,:), RevData{k}.avg_Fz_inner, 0, 'coeff');
        crMxi(rev) = xcorr(SortedData.Mx_inner{k}(rev,:), RevData{k}.avg_Mx_inner, 0, 'coeff');
        crMyi(rev) = xcorr(SortedData.My_inner{k}(rev,:), RevData{k}.avg_My_inner, 0, 'coeff');
        crMzi(rev) = xcorr(SortedData.Mz_inner{k}(rev,:), RevData{k}.avg_Mz_inner, 0, 'coeff');
    end
   
    figure;
    subplot(231)
    plot(crFxo, 'r.-', 'MarkerSize', 15); hold on; plot(crFxi, 'b.-', 'MarkerSize', 15);
    grid on
    line([0 SortedData.nrevs{k}], [threshold threshold]);
    ylabel('Correlation coefficient');
    legend('Outer', 'Inner');

    subplot(232)
    plot(crFyo, 'r.-', 'MarkerSize', 15); hold on; plot(crFyi, 'b.-', 'MarkerSize', 15);
    grid on
    line([0 SortedData.nrevs{k}], [threshold threshold]);
    aa = split(SortedData.names{k}, '_test_');
    bb = split(aa{2}, '.csv');
    title(bb{1});

    subplot(233)
    plot(crFzo, 'r.-', 'MarkerSize', 15); hold on; plot(crFzi, 'b.-', 'MarkerSize', 15);
    grid on
    line([0 SortedData.nrevs{k}], [threshold threshold]);

    subplot(234)
    plot(crMxo, 'r.-', 'MarkerSize', 15); hold on; plot(crMxi, 'b.-', 'MarkerSize', 15);
    grid on
    line([0 SortedData.nrevs{k}], [threshold threshold]);
    ylabel('Correlation coefficient');
    xlabel('Rev. number');

    subplot(235)
    plot(crMyo, 'r.-', 'MarkerSize', 15); hold on; plot(crMyi, 'b.-', 'MarkerSize', 15);
    grid on
    line([0 SortedData.nrevs{k}], [threshold threshold]);
    xlabel('Rev. number');

    subplot(236)
    plot(crMzo, 'r.-', 'MarkerSize', 15); hold on; plot(crMzi, 'b.-', 'MarkerSize', 15);
    grid on
    line([0 SortedData.nrevs{k}], [threshold threshold]);
    xlabel('Rev. number');


%     SortedData.badrevs{k} = ((crFxo<threshold) | (crFyo<threshold) | (crFzo<threshold) ...
%        | (crMxo<threshold) | (crMyo<threshold) | (crMzo<threshold) ...
%        | (crFxi<threshold) | (crFyi<threshold) | (crFzi<threshold) ...
%        | (crMxi<threshold) | (crMyi<threshold) | (crMzi<threshold));
       SortedData.badrevs{k} = ((crFxo<threshold) | (crFyo<threshold) | (crFzo<threshold) ...
       | (crMxo<threshold) | (crMyo<threshold) | (crMzo<threshold) ...
       | (crFxi<threshold) | (crFyi<threshold) ...
       | (crMxi<threshold) | (crMyi<threshold)); % ==1 if a bad revolution
    
   pause
   clf
   
   SortedData.Fx_outer{k} = SortedData.Fx_outer{k}(~SortedData.badrevs{k},:);
   SortedData.Fy_outer{k} = SortedData.Fy_outer{k}(~SortedData.badrevs{k},:);
   SortedData.Fz_outer{k} = SortedData.Fz_outer{k}(~SortedData.badrevs{k},:);
   SortedData.Mx_outer{k} = SortedData.Mx_outer{k}(~SortedData.badrevs{k},:);
   SortedData.My_outer{k} = SortedData.My_outer{k}(~SortedData.badrevs{k},:);
   SortedData.Mz_outer{k} = SortedData.Mz_outer{k}(~SortedData.badrevs{k},:);
        
   SortedData.Fx_inner{k} = SortedData.Fx_inner{k}(~SortedData.badrevs{k},:);
   SortedData.Fy_inner{k} = SortedData.Fy_inner{k}(~SortedData.badrevs{k},:);
   SortedData.Fz_inner{k} = SortedData.Fz_inner{k}(~SortedData.badrevs{k},:);
   SortedData.Mx_inner{k} = SortedData.Mx_inner{k}(~SortedData.badrevs{k},:);
   SortedData.My_inner{k} = SortedData.My_inner{k}(~SortedData.badrevs{k},:);
   SortedData.Mz_inner{k} = SortedData.Mz_inner{k}(~SortedData.badrevs{k},:);
   
   SortedData.cts_inner{k} = SortedData.cts_inner{k}(~SortedData.badrevs{k},:);
   SortedData.cps_inner{k} = SortedData.cps_inner{k}(~SortedData.badrevs{k},:);
   SortedData.cts_outer{k} = SortedData.cts_outer{k}(~SortedData.badrevs{k},:);
   SortedData.cps_outer{k} = SortedData.cps_outer{k}(~SortedData.badrevs{k},:);
   
   
end

end