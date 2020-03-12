function caldata = CalProc(testdate, testletter, calsuffix, plots)
% READ CALIBRATION FILES AND PLOT EACH FFT
% sirohi 200227 
% MODIFIED CMJOHNSON 03/03/2020
%
% INPUTS
%     testdate          -> format: % "testdate"_test_"testletter"_cal"calsuffix" - 01 Start - 1.wav
%     testletter
%     calsuffix
%     plots = true or false
% OUTPUTS
%     caldata
%         .fvec
%         .fs
%         .wavdata
%         .tvec
%         .calmag
%         .scale
%
% sirohi 200227
% 
% MODIFIED CMJOHNSON 03/03/2020
caldata = struct('scale', [], 'calmag', [], 'tvec',[],'wavdata',[],'fs',[],'fvec',[]);


calprefix = ['./Uber Acoustics ' testdate '/Audio Files/' testdate '_test_' testletter '_cal' calsuffix ' - 01 Start - '];

% read the calibration files
for micnum = 1:16
    fname = [calprefix num2str(micnum) '.wav'];
    if isfile(fname)
        [caldata(micnum).wavdata, caldata(micnum).fs] = audioread(fname);
        caldata(micnum).tvec = 0: 1/caldata(micnum).fs: (length(caldata(micnum).wavdata)-1)/caldata(micnum).fs;
        [caldata(micnum).fvec, caldata(micnum).calmag, ~, ~] = ffind_dft(caldata(micnum).tvec, caldata(micnum).wavdata, 0);
        caldata(micnum).scale = max(caldata(micnum).calmag);
        
        if (plots)
            loglog(caldata(micnum).fvec, caldata(micnum).calmag);
            xlabel('Frequency, Hz');
            ylabel('Magnitude');
            legend(['Mic. ' num2str(micnum)]);
            disp(['Mic. ' num2str(micnum) ' - Magnitude at ' num2str(caldata(micnum).fvec(caldata(micnum).calmag== caldata(micnum).scale)) ' Hz: ' num2str(caldata(micnum).scale) ]);
            pause
        end
        
    end
end

