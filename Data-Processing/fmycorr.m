function [jcorr, lags, corrshift] = fmycorr(Vs1, Vs2, maxshift)
%-------------------------------------------------------------------------
% correlation function. the output is not actually scaled, it is
% just integral Vs1(t)* Vs2(t-lag)
%
% INPUTS:
% Vs1 - first vector, time series
% Vs2 - second vector, time series
% maxshift - maximum number of indices to shift
%
% OUTPUTS:
% jcorr - vector of "correlations"
% lags - vector of lags
% corrshift - number of indices Vs2 should be shifted by to match Vs1
%
% sirohi 1921130
%-------------------------------------------------------------------------

jcorr = [];
lags = [];
for lag = -maxshift:1000:maxshift
    g = circshift(Vs2,lag);
    jcorr = [jcorr sum(Vs1.*g)];
    lags = [lags lag];
end

[~,corrshift] = max(abs(jcorr));

end

