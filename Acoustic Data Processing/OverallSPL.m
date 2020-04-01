function oaspl = OverallSPL(P)
% CALCULATES OVERALL SOUND PRESSURE LEVEL IN DECIBELS

P_ref = 20E-6;
rss_P = sqrt(nansum(P.^2));

oaspl = 20*log10(rss_P / P_ref);