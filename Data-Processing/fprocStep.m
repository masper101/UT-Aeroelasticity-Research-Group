function [ipt] = fprocStep(datain,filtoptions,lenends,FS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Function is used to determine when the step input occurs.
%
% Function(s) called:
% (1) fcleanup
% 
% INPUTS:
%        datain = Data with step input to analyze (i.e. Fz_outer)
%        filtoptions = Options for which filters to apply (Set in
%                     StepProcess)
%        lenends = Offset added before and after identified step region
%                  needed for extracting data before / during / and after
%        FS = Sampling frequency (Hz)
%
% OUTPUTS:
%        ipt = Limits before and after step region. Used to organize data 
%              before / during / after step 
% 
% CREATED: Patrick Mortimer 04/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ndata = length(datain);

% Filter the signal and append it to the theta_data structure
for ii = 1:ndata
    
    npts(ii)      = length(datain{1,ii});
    data(ii).tvec = [0:1/FS:(npts(ii)-1)/FS]';
    datalen(ii)   = length(data(ii).tvec);
    
    % Smoothdata filter    
    if filtoptions.smooth == true
    
        data(ii).filt_var = fcleanup(datain{1,ii}, 'smoothdata', 'lowess', filtoptions.wndw); 
    
    end
    
    % Moving average filter
    if filtoptions.moveavg == true
    
        data(ii).filt_var = fcleanup(datain{1,ii}, 'movmean', 20);
    
    end
    
    % Lowpass followed by bandstop removing first three N/rev harmonics
    if filtoptions.Lpass == true
        
        data(ii).filt_var = fcleanup(datain{1,ii},0,3,lenends,100,FS,15);
    
    end
     
end

% Cut all the data to the same length
datalen = min(datalen);

% Cut time vector
ctvec = data(1).tvec(lenends:datalen-lenends);

for ii = 1:ndata
    
    data(ii).cvar = datain{1,ii}(lenends:datalen-lenends);
    data(ii).cfilt_var = data(ii).filt_var(lenends:datalen-lenends);
    
    ipt(:,ii) = findchangepts(data(ii).cfilt_var,'Statistic','linear','MaxNumChanges',2);
    ipt(1,ii) = (ipt(1,ii) - lenends);
    ipt(2,ii) = (ipt(2,ii) + lenends);
    tval(:,ii) = ctvec(ipt(:,ii));
    
    % Plot everything
    figure(1);
    subplot(ndata,1,ii);
    plot(ctvec, data(ii).cvar, 'r-');
    hold on
    plot(ctvec, data(ii).cfilt_var, 'k-');
    xline(tval(1,ii));
    xline(tval(2,ii));
    grid
    xlabel('Time, s');
    
end

% End of function

end