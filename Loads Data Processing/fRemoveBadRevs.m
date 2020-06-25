function [SortedData,RevData] = fRemoveBadRevs(SortedData, RevData)
% CHECK CORRELATION OF DATA AND REMOVE THE BAD REVOLUTIONS, SAVED TO
% "SortedData" and "RevData"

% CMJOHNSON 06/02/2020

fprintf('\n%s\n', 'Checking correlation');
visualize = input('Visualize (v) correlation data? ', 's');
[SortedData, RevData] = fCheckCorrelation(SortedData, RevData, visualize);
Nrevmax = 20; %number of max revs to remove


iteration_criteria = 1;
Totalbadrevs = zeros(1,length(SortedData.names));

while iteration_criteria > 0
    for k = 1:length(SortedData.names)      
        Nbadrevs(k) = sum(SortedData.badrevs{k});
        
        if 0<Nbadrevs(k) && Nbadrevs(k)< Nrevmax
            Totalbadrevs(k) = Totalbadrevs(k) + Nbadrevs(k);
            % NEW SortedData WITH BAD REVS REMOVED
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
            SortedData.nrevs{k} = SortedData.nrevs{k} - sum(SortedData.badrevs{k});
            flag(k) = 0;
        elseif Nbadrevs(k)> Nrevmax
            flag(k) = 1;
            Totalbadrevs(k) = Nbadrevs(k);
        end
    end
    
    iteration_criteria = sum(((Nbadrevs<Nrevmax)&(Nbadrevs>0)));
   
    % REAVERAGE DATA
    RevData = fRevolutionAvg(SortedData); %NEW RevData WITH BAD REVS REMOVED
    
    if iteration_criteria>0
    % CHECK NEW CORRELATION
    fprintf('\t%s\n', 'Re-checking correlation');
    [SortedData, RevData] = fCheckCorrelation(SortedData, RevData, visualize);
    end
    
end

if visualize == 'v'
    fprintf('\tCorrelation done\n')
end

for k = 1:length(SortedData.names)
    fprintf('\t%s', ['- ' SortedData.names{k} ' ... Nbadrevs: ' num2str(Totalbadrevs(k)) '...']);

    if Totalbadrevs(k) == 0
        fprintf(' No bad revs\n')
    elseif flag(k) == 1
        fprintf('%s\n',[' >', num2str(Nrevmax),'. No revs removed']);
    elseif flag(k) == 0
        fprintf(' Removed bad revs\n')
    end
    
end




