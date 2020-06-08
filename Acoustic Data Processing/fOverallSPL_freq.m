function oaspl = fOverallSPL_freq(Pvec)
% CALCULATES OVERALL SOUND PRESSURE LEVEL IN DECIBELS
% P IN FREQ DOMAIN

P_ref = 20E-6;
rms_P = sqrt(nansum(Pvec.^2)/2);

oaspl = 20*log10(rms_P / P_ref);