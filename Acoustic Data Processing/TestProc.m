function testdata = TestProc(testdate, testletter, plots, caldata)
% READ AND CONVERT TEST FILES INTO DB VALUES, PLOT EACH MIC
% CMJOHNSON 03/03/2020
% INPUTS
%     caldata                 -> get calibration factors
%     testdate
%     testletter
%     plots = true or false
% OUTPUTS
%     testdata
%         .fvec               -> frequency vector (1 x 240000)
%         .fs                 -> sampling frequency (48000 Hz)
%         .wavdata            -> data in .wav file (480000 x 1)
%         .tvec               -> time vector (1 x 240000)
%         .testmag            -> magnitudes of .wav file in freq. domain
%                                (240000 x 1)
%         .Pdata [Pa]         -> pressure magnitudes in freq.
%                                domain (240000 x 1)
%         .dbdata             -> pressure magnitudes in freq. domain
%                                converted to dB (240000 x 1)
%         .pvst [Pa]          -> pressure in time domain (240000 x 1)
%   

Pref = 20E-6; %[Pa]
testdata = struct('dbdata',[],'Pdata',[],'testmag',[],'tvec',[],'wavdata',[],'fs',[],'fvec',[]);
testprefix = ['./Uber Acoustics ' testdate '/Audio Files/' testdate '_test_' testletter ' - 01 Start - '];

% Afilt = WeightingFilter('A-weighting',48000);

% read the test files
for micnum = 1:16
    fname = [testprefix num2str(micnum) '.wav'];
    if isfile(fname)
        [testdata(micnum).wavdata, testdata(micnum).fs] = audioread(fname);
        testdata(micnum).tvec = 0: 1/testdata(micnum).fs: (length(testdata(micnum).wavdata)-1)/testdata(micnum).fs;
        [testdata(micnum).fvec, testdata(micnum).testmag, ~, ~] = ffind_dft(testdata(micnum).tvec, testdata(micnum).wavdata, 0);
%         df = 0.1;   % desired frequency resolution, Hz
%         [testdata(micnum).fvec, testdata(micnum).testmag, ~] = ffind_spectrum(testdata(micnum).fs,...
%             testdata(micnum).wavdata, testdata(micnum).fs/df, 5);%length(micdata(micnum).tvec), 1);

        testdata(micnum).Pdata = testdata(micnum).testmag * caldata(micnum).calfactor /2; %PRESSURE DOUBLING AT RIGID SURFACE
        testdata(micnum).pvst = testdata(micnum).wavdata * caldata(micnum).calfactor /2; %PRESSURE DOUBLING AT RIGID SURFACE
        %testdata(micnum).APdata = Afilt(testdata(micnum).Pdata);
        
        [testdata(micnum).ofilt12_fvec,testdata(micnum).ofilt12_Pdata] = OctaveFilter(testdata(micnum).fvec,testdata(micnum).Pdata,12);
        [testdata(micnum).ofilt3_fvec,testdata(micnum).ofilt3_Pdata] = OctaveFilter(testdata(micnum).fvec,testdata(micnum).Pdata,3);
        
        testdata(micnum).dbdata = 20*log10(testdata(micnum).Pdata / Pref);
        % testdata(micnum).dbAdata = 20*log10(testdata(micnum).APdata/Pref);
        testdata(micnum).ofilt12_dbdata = 20*log10(testdata(micnum).ofilt12_Pdata / Pref); 
        testdata(micnum).ofilt3_dbdata = 20*log10(testdata(micnum).ofilt3_Pdata / Pref); 
        
        testdata(micnum).oaspl = OverallSPL(testdata(micnum).Pdata); 
        % testdata(micnum).oaspla = OverallSPL(testdata(micnum).APdata);
        
    end
end

if (plots)
    %TIME DOMAIN
    figure(1)
    for micnum = 1:8
        subplot(8,1,micnum)
        plot(testdata(micnum).tvec, testdata(micnum).wavdata)
        axis([0 1 -0.5 0.5]);
        legend(['Mic ' num2str(micnum)]);
    end
    xlabel('Time, s')
    
    figure(2)
    for micnum = 9:16
        subplot(8,1,micnum-8)
        plot(testdata(micnum).tvec, testdata(micnum).wavdata)
        axis([0 1 -0.5 0.5]);
        legend(['Mic ' num2str(micnum)]);
    end
    xlabel('Time, s')
    
    %FREQ DOMAIN
    figure(11)
    for micnum = 1:8
        subplot(8,1,micnum)
        semilogx(testdata(micnum).fvec, testdata(micnum).dbdata)
        xlim([10^1 10^4]);
        legend(['Mic ' num2str(micnum)]);
    end
    xlabel('Frequency, Hz')
    
    figure(12)
    for micnum = 9:16
        subplot(8,1,micnum-8)
        semilogx(testdata(micnum).fvec, testdata(micnum).dbdata)
        xlim([10^1 10^4]);
        legend(['Mic ' num2str(micnum)]);
    end
    xlabel('Frequency, Hz')
end
