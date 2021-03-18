function [caldata] = fCalProc2(calprefix)
% READ CALIBRATION FILES AND PLOT EACH FFT
% sirohi 200227
% MODIFIED CMJOHNSON 05/15/2020
%
% INPUTS
%     calprefix -> from fAcProc          
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
cal_db = 114;

%% read the calibration files
% fprintf('\t')
% worv = input('Visualize (v) calibration data ? ', 's');
worv ='n';
for micnum = 1:16
    fname = [calprefix num2str(micnum) '.wav'];
    if isfile(fname)
        fprintf('\t%s',['- Mic ', num2str(micnum),' ... '])
        [caldata(micnum).wavdata, caldata(micnum).fs] = audioread(fname);
        caldata(micnum).tvec = 0: 1/caldata(micnum).fs: (length(caldata(micnum).wavdata)-1)/caldata(micnum).fs;
        
        %[caldata(micnum).fvec, caldata(micnum).calmag, ~, ~] = ffind_dft(caldata(micnum).tvec, caldata(micnum).wavdata, 0);
        fs = 48000;
        NFFT = 32768;
        Nav = 31;
        win = 'hann';
        [caldata(micnum).fvec, caldata(micnum).calmag, ~] = ffind_spectrum(fs, caldata(micnum).wavdata, NFFT, Nav, win);
        
        %ASSUMING PERFECT SIN WAV
        %caldata(micnum).scale = max(caldata(micnum).calmag);
        
        %ASSUMING IMPERFECT SIN WAV
        caldata(micnum).scale = sqrt(sum(caldata(micnum).wavdata.^2)/length(caldata(micnum).wavdata));   
        caldata(micnum).calfactor = fCalFactor(caldata, cal_db,micnum);

        %CHECK CALIBRATION
        OASPL = fOverallSPL_freq(caldata(micnum).calfactor * caldata(micnum).calmag);
        fprintf('%s\n',['OASPL = ',num2str(OASPL)])
        
        switch worv
            case 'v'
                figure(22)
                subplot(2,1,1)
                plot(caldata(micnum).tvec, caldata(micnum).wavdata);
                grid on; grid minor;
                xlabel('Time, s');
                ylabel('Magnitude');
                legend(['Mic. ' num2str(micnum)]);
                xlim([0,.01])
                
                subplot(2,1,2)
                set(gca,'xscale','log')
                set(gca,'yscale','log')
                loglog(caldata(micnum).fvec, caldata(micnum).calmag);
                grid on; grid minor;
                xlabel('Frequency, Hz');
                ylabel('Magnitude');
                legend(['Mic. ' num2str(micnum)]);
                
%                 figure(23)
%                 set(gca,'xscale','log')
%                 semilogx(caldata(micnum).fvec, 20*log10(caldata(micnum).calmag*caldata(micnum).calfactor./20E-6));
%                 grid on; grid minor;
%                 xlabel('Frequency, Hz');
%                 ylim([-20,120])
%                 xlim([10,10^4+10000])
%                 ylabel('dB');
%                 micSN = [223 214 221 222 202 177 199 191 189 205 188 107 220 219 203];
%                 micserialnum = micSN(micnum);
%                 title(['10/27/20: 114 dB Calibration, Mic ' num2str(micserialnum)]);
%                 set(gca, 'FontName', 'Times New Roman')
%                 set(gca, 'FontSize', 14)
%                 filename = ['mic' num2str(micserialnum) '.png'];
%                 saveas(gcf,filename)
                pause
                
                
            otherwise
        end
    else
        fprintf(['File ', fname,' not found\n'])
    end
end
close(figure(22))
end



