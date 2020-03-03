function caldata = CalFactor(caldata, cal_db)
% CALCULATES CALIBRATION FACTOR IN [Pa /.WAV UNITS]
% CMJOHNSON 03/03/2020
% INPUTS
%     caldata.scale         -> maximum .wav value in calibration recordings
%     cal_db                -> decibel value of calibrator
%
% OUTPUTS
%     caldata.calfactor    -> calibration factor, mulitply wav files by factor to get mic pressure
    


P_ref = 20e-6;
cal_P = 10^(cal_db / 20) * P_ref;

for micnum = 1:16
    caldata(micnum).calfactor = cal_P / caldata(micnum).scale;
end
