function calfactor = CalFactor(caldata, cal_db,  micnum)
% CALCULATES CALIBRATION FACTOR IN [Pa /.WAV UNITS]
% CMJOHNSON 03/03/2020
% INPUTS
%     caldata.scale         -> maximum .wav value in calibration recordings
%     cal_db                -> decibel value of calibrator
%
% OUTPUTS
%     caldata.calfactor    -> calibration factor, mulitply wav files by factor to get mic pressure


P_ref = 20e-6;
cal_P = 10^(cal_db / 20) * P_ref * sqrt(2);

calfactor = cal_P / caldata(micnum).scale;
