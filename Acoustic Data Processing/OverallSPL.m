function oaspl = OverallSPL(Pvec,tvec)
% CALCULATES OVERALL SOUND PRESSURE LEVEL IN DECIBELS

% rss_P = sqrt(nansum(P.^2));
P_ref = 20E-6;
rms_P = sqrt(nansum(Pvec.^2)/length(tvec));

oaspl = 20*log10(rms_P / P_ref);