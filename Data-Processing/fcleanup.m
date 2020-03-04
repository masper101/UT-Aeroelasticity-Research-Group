function [filt_Vs] = fcleanup(Vs, method, arg, winlen, fl, fs, fr)
%-------------------------------------------------------------------------
% function to clean up time signal using either a filter or a smoothing
% algorithm
%
% INPUTS :
% Vs - signal time series
% method - filtering/ smoothing algorithm
% arg - number of harmonics or number of data points for smoothing method
% winlen - number of elements at the ends to zero out
% fl - low-pass cut-off frequency, Hz
% fs - sampling frequency, Hz
% fr - 1/rev frequency, Hz
%
% OUTPUTS :
% filt_Vs - filtered signal time series
%
% sirohi 191129
%-------------------------------------------------------------------------

if (nargin==7) % first low pass the signal and then band stop 'arg' harmonics
    
    % define a windowing function to make the ends of the signal = 0
    trad = linspace(0,1,winlen)*pi;
    winfn = [0.5-cos(trad)*0.5 ones(1,length(Vs)-2*winlen) cos(trad)*0.5+0.5]';
    wVs = Vs .*winfn;
    
    % lowpass filter
    filt_Vs = lowpass(wVs, fl, fs , 'StopbandAttenuation', 80, 'Steepness', 0.95);
    
    % bandstop filter
    for ii = 1:arg
        filt_Vs = bandstop(filt_Vs, [ii*fr-5 ii*fr+5], fs);  % remove ii/rev +/- 5Hz
    end
    
else
    if strcmp(method, 'movmean') % moving average
        eval(['filt_Vs = ' method '(Vs, ' num2str(arg) ');']);
    elseif strcmp(method, 'smoothdata') % smoothing filter defined in matlab
        eval(['filt_Vs = ' method '(Vs, arg , ' num2str(winlen) ');']);
    end
end

end

