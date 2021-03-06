function caldata = CalProc(testdate, testletter, calsuffix, cal_db, plots)
% READ CALIBRATION FILES AND PLOT EACH FFT
% sirohi 200227 
% MODIFIED CMJOHNSON 05/15/2020
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

caldata = struct('scale', [], 'calmag', [], 'tvec',[],'wavdata',[],'fs',[],'fvec',[]);


% calprefix = ['./Uber Acoustics ' testdate '/Audio Files/' testdate '_test_' testletter '_cal' calsuffix ' - 01 Start - '];
calprefix = [testdate '_test_' testletter '_cal' calsuffix ' - 01 Start - '];

% read the calibration files
for micnum = 1:16
    fname = [calprefix num2str(micnum) '.wav'];
    if isfile(fname)
        [caldata(micnum).wavdata, caldata(micnum).fs] = audioread(fname);
        caldata(micnum).tvec = 0: 1/caldata(micnum).fs: (length(caldata(micnum).wavdata)-1)/caldata(micnum).fs;
        
%         [caldata(micnum).fvec, caldata(micnum).calmag, ~, ~] = ffind_dft(caldata(micnum).tvec, caldata(micnum).wavdata, 0);
        fs = 48000;
        NFFT = 32768;
        Nav = 31;
        win = 'hann';
        [caldata(micnum).fvec, caldata(micnum).calmag, ~] = ffind_spectrum(fs, caldata(micnum).wavdata, NFFT, Nav, win);
        
        %ASSUMING PERFECT SIN WAV
        %caldata(micnum).scale = max(caldata(micnum).calmag);
        
        %ASSUMING IMPERFECT SIN WAV
        caldata(micnum).scale = sqrt(sum(caldata(micnum).wavdata.^2)/length(caldata(micnum).wavdata));
        
        caldata(micnum).calfactor = CalFactor(caldata, cal_db,micnum);
%         
%         hf = figure(micnum);
%         semilogx(caldata(micnum).fvec, 20*log10(caldata(micnum).calfactor*caldata(micnum).calmag/20E-6));
%         title(['114 dB Calibration: Mic ',num2str(micnum),', 02/27/20'])
%         xlabel('Frequency [Hz]')
%         ylabel('dB')
%         xlim([10,20000])
%         grid on
%         grid minor
%         ylim([-20,120])
%         set(gca, 'fontsize',16,'fontname','Times')
        
        if (plots)
        subplot(2,1,1)
        plot(caldata(micnum).tvec, caldata(micnum).wavdata);
        grid on; grid minor;
        xlabel('Time, s');
        ylabel('Magnitude');
        legend(['Mic. ' num2str(micnum)]);
        xlim([0,.01])
        
        subplot(2,1,2)
%         hold on
        set(gca,'xscale','log')
        set(gca,'yscale','log')
        loglog(caldata(micnum).fvec, caldata(micnum).calmag);
        grid on; grid minor;
        xlabel('Frequency, Hz');
        ylabel('Magnitude');
        legend(['Mic. ' num2str(micnum)]);
%         hold off
        
        disp(['Mic. ' num2str(micnum) ' - Magnitude at ' num2str(caldata(micnum).fvec(caldata(micnum).calmag== caldata(micnum).scale)) ' Hz: ' num2str(caldata(micnum).scale) ]);
        pause
        end
        
    end
end



