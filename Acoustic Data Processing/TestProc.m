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
%         .fvec
%         .fs
%         .wavdata
%         .tvec
%         .testmag
%         .Pdata [Pa]
%         .dbdata

Pref = 20E-6; %[Pa]
testdata = struct('dbdata',[],'Pdata',[],'testmag',[],'tvec',[],'wavdata',[],'fs',[],'fvec',[]);
testprefix = [testdate '_test_' testletter ' - 01 Start - '];

% read the test files
for micnum = 1:16
    fname = [testprefix num2str(micnum) '.wav'];
    if isfile(fname)
        [testdata(micnum).wavdata, testdata(micnum).fs] = audioread(fname);
        testdata(micnum).tvec = 0: 1/testdata(micnum).fs: (length(testdata(micnum).wavdata)-1)/testdata(micnum).fs;
        [testdata(micnum).fvec, testdata(micnum).testmag, ~, ~] = ffind_dft(testdata(micnum).tvec, testdata(micnum).wavdata, 0);
        
        testdata(micnum).Pdata = testdata(micnum).testmag * caldata(micnum).calfactor /2; %PRESSURE DOUBLING AT RIGID SURFACE
        testdata(micnum).dbdata = 20*log10(testdata(micnum).Pdata / Pref); 
        testdata(micnum).oaspl = OverallSPL(testdata(micnum).Pdata); 
        
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
