% code to open and visualize the calibration wav files 
% from the acoustic array
%
% filename should be:
% *_test_#_cal& - 01 Start - 1.wav
% where:
% * == filedate (200208)
% # == testletter (a)
% & == calprefix ([] or 2 or...)
%
% 200208_test_a_cal - 01 Start - 1.wav
%
% sirohi 200227
%
clc
%close all
clear all

micdata = struct('scale', [], 'calmag', [], 'tvec',[],'wavdata',[],'fs',[],'fvec',[]);

testdate = '200227';
testletter = 'd';
calsuffix = '3';
calprefix = [testdate '_test_' testletter '_cal' calsuffix ' - 01 Start - '];

% read the calibration files
for micnum = 12;%1:16
    fname = ['./Uber Acoustics ' testdate '/Audio Files/' calprefix num2str(micnum) '.wav'];
    if isfile(fname)
        [micdata(micnum).wavdata, micdata(micnum).fs] = audioread(fname);
        micdata(micnum).tvec = 0: 1/micdata(micnum).fs: (length(micdata(micnum).wavdata)-1)/micdata(micnum).fs;
        [micdata(micnum).fvec, micdata(micnum).calmag, ~, ~] = ffind_dft(micdata(micnum).tvec, micdata(micnum).wavdata, 0);
        % df = 0.1;   % desired frequency resolution, Hz
        % [micdata(micnum).fvec, micdata(micnum).calmag, ~] = ffind_spectrum(micdata(micnum).fs,...
        % micdata(micnum).wavdata, micdata(micnum).fs/df, 3);%length(micdata(micnum).tvec), 1);
        figure(10);
        loglog(micdata(micnum).fvec, micdata(micnum).calmag);
        xlabel('Frequency, Hz');
        ylabel('Magnitude');
        legend(['Mic. ' num2str(micnum)]);
        
        figure(11);
        Nb = 18; % number of blocks
        ov = 0.5;   % overlap ratio of blocks
        lb = floor( length(micdata(micnum).wavdata) /(Nb -(Nb-1)*ov) );
        nfft = max(256, 2^nextpow2(lb));   % number of points to use for FFT
        spectrogram(micdata(micnum).wavdata, rectwin(lb), floor(ov*lb), nfft, 48000, 'power');
        
        micdata(micnum).scale = max(micdata(micnum).calmag);
        disp(['Mic. ' num2str(micnum) ' - Magnitude at ' num2str(micdata(micnum).fvec(micdata(micnum).calmag== micdata(micnum).scale)) ' Hz: ' num2str(micdata(micnum).scale) ]);
        pause
    end
end

