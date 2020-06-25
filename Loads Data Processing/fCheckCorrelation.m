function [SortedData, RevData] = fCheckCorrelation(SortedData, RevData, visualize)

% calculates cross-correlation of each revolution (Fz_inner and Fz_outer)
% with the mean over all revolutions

threshold = 0.9;     % how different the revolutions can be

% Omega160 full-scale loads
% SI-1000-120 calibration
FSLoad = [1000	1000 2500 120 120 120]; % Fx Fy Fz (N) Mx My Mz (Nm)
% SI-1500-240 calibration
%FSLoad = [1500 1500 3750 240 240 240];
% SI-2500-400 calibration
%FSLoad = [2500 2500	6250 400 400 400];

if nargin == 2
    worv = input('Visualize (v) correlation data? ', 's');
else
    worv = visualize;
end

for k = 1:length(SortedData.names)
    
    for rev = 1:SortedData.nrevs{k}
        crFxo(rev) = xcorr(SortedData.Fx_outer{k}(rev,:), RevData.avg_Fx_outer{k}, 0, 'coeff');
        crFyo(rev) = xcorr(SortedData.Fy_outer{k}(rev,:), RevData.avg_Fy_outer{k}, 0, 'coeff');
        crFzo(rev) = xcorr(SortedData.Fz_outer{k}(rev,:), RevData.avg_Fz_outer{k}, 0, 'coeff');
        crMxo(rev) = xcorr(SortedData.Mx_outer{k}(rev,:), RevData.avg_Mx_outer{k}, 0, 'coeff');
        crMyo(rev) = xcorr(SortedData.My_outer{k}(rev,:), RevData.avg_My_outer{k}, 0, 'coeff');
        crMzo(rev) = xcorr(SortedData.Mz_outer{k}(rev,:), RevData.avg_Mz_outer{k}, 0, 'coeff');
        
        crFxi(rev) = xcorr(SortedData.Fx_inner{k}(rev,:), RevData.avg_Fx_inner{k}, 0, 'coeff');
        crFyi(rev) = xcorr(SortedData.Fy_inner{k}(rev,:), RevData.avg_Fy_inner{k}, 0, 'coeff');
        crFzi(rev) = xcorr(SortedData.Fz_inner{k}(rev,:), RevData.avg_Fz_inner{k}, 0, 'coeff');
        crMxi(rev) = xcorr(SortedData.Mx_inner{k}(rev,:), RevData.avg_Mx_inner{k}, 0, 'coeff');
        crMyi(rev) = xcorr(SortedData.My_inner{k}(rev,:), RevData.avg_My_inner{k}, 0, 'coeff');
        crMzi(rev) = xcorr(SortedData.Mz_inner{k}(rev,:), RevData.avg_Mz_inner{k}, 0, 'coeff');
    end
    
%     SortedData.badrevs{k} = ((crFxo<threshold) | (crFyo<threshold) | (crFzo<threshold) ...
%         | (crMxo<threshold) | (crMyo<threshold) | (crMzo<threshold) ...
%         | (crFxi<threshold) | (crFyi<threshold) | (crFzi<threshold) ...
%         | (crMxi<threshold) | (crMyi<threshold) | (crMzi<threshold));
    
    SortedData.badrevs{k} = ((crFxo<threshold) | (crFyo<threshold) | (crFzo<threshold) ...
        | (crMxo<threshold) | (crMyo<threshold) | (crMzo<threshold) ...
        | (crFxi<threshold) | (crFyi<threshold) ...
        | (crMxi<threshold) | (crMyi<threshold)); % == 1 if bad rev
    
    switch worv
        case 'v'
            fprintf('\t%s', ['- ' SortedData.names{k} ' ... ']);
            Nbadrevs = sum(SortedData.badrevs{k});
            fprintf('%s\n', ['Nbadrevs: ' num2str(Nbadrevs)]);
            
            figure(22);
            subplot(231)
            plot(crFxo, 'r.-', 'MarkerSize', 15); hold on;
            plot(crFxi, 'b.-', 'MarkerSize', 15);
            grid on
            line([0 SortedData.nrevs{k}], [threshold threshold]);
            ylabel('Correlation coefficient');
            legend('Outer', 'Inner');
            title('F_x')
            
            subplot(232)
            plot(crFyo, 'r.-', 'MarkerSize', 15); hold on;
            plot(crFyi, 'b.-', 'MarkerSize', 15);
            grid on
            line([0 SortedData.nrevs{k}], [threshold threshold]);
            title('F_y')
            aa = split(SortedData.names{k}, '_test_');
            bb = split(aa{2}, '.csv');
            if ~verLessThan('MATLAB','9.5')
                sgtitle(bb{1});
            end
            
            subplot(233)
            plot(crFzo, 'r.-', 'MarkerSize', 15); hold on;
            %             plot(crFzi, 'b.-', 'MarkerSize', 15);
            grid on
            line([0 SortedData.nrevs{k}], [threshold threshold]);
            title('F_z')
            
            subplot(234)
            plot(crMxo, 'r.-', 'MarkerSize', 15); hold on;
            plot(crMxi, 'b.-', 'MarkerSize', 15);
            grid on
            line([0 SortedData.nrevs{k}], [threshold threshold]);
            ylabel('Correlation coefficient');
            xlabel('Rev. number');
            title('M_x')
            
            subplot(235)
            plot(crMyo, 'r.-', 'MarkerSize', 15); hold on;
            plot(crMyi, 'b.-', 'MarkerSize', 15);
            grid on
            line([0 SortedData.nrevs{k}], [threshold threshold]);
            xlabel('Rev. number');
            title('M_y')
            
            subplot(236)
            plot(crMzo, 'r.-', 'MarkerSize', 15); hold on;
            %             plot(crMzi, 'b.-', 'MarkerSize', 15);
            grid on
            line([0 SortedData.nrevs{k}], [threshold threshold]);
            xlabel('Rev. number');
            title('M_z')
            pause
            clf
        otherwise
    end 
    
    clear crFxi crFxo crFyi crFyo crFzi crFzo crMxi crMxo crMyi crMyo crMzi crMzo
    close(figure(22))
end

end