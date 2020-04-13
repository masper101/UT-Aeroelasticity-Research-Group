function caldata = CalProc_SaveMem(testdate, testletter, calsuffix, cal_db)
% READ CALIBRATION FILES AND PLOT EACH FFT
% sirohi 200227 
% MODIFIED CMJOHNSON 03/25/2020
%
% INPUTS
%     testdate          -> format: % "testdate"_test_"testletter"_cal"calsuffix" - 01 Start - 1.wav
%     testletter
%     calsuffix
% OUTPUTS
%     caldata
%         .scale

%
% sirohi 200227
% 
% MODIFIED CMJOHNSON 03/03/2020
caldata = struct('scale', []);


calprefix = [testdate '_test_' testletter '_cal' calsuffix ' - 01 Start - '];

% read the calibration files
for micnum = 1:16
    fname = [calprefix num2str(micnum) '.wav'];
    if isfile(fname)
        [wavdata, fs] = audioread(fname);
        tvec = 0: 1/fs: (length(wavdata)-1)/fs;
        [fvec, calmag, ~, ~] = ffind_dft(tvec, wavdata, 0);
        caldata(micnum).scale = max(calmag);
        caldata(micnum).calfactor = CalFactor(caldata, cal_db,  micnum);
    end
end

