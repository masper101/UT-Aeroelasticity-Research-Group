function testdata = TestProc_SingleMic(testdate, testletter,micnums, caldata, plots)
% READ AND CONVERT TEST FILES INTO DB VALUES, PLOT EACH MIC
% CMJOHNSON 03/25/2020
% INPUTS
%     caldata                 -> get calibration factors
%     testdate
%     testletter
%     micnums
%     plots = true or false
% OUTPUTS
%     testdata
%         .fvec
%         .fs
%         .wavdata
%         .tvec
%         .testmag
%         .Pdata [Pa]
%         .Pdata_t [Pa]       -> Pressure in time domain
%         .dbdata
%         .ofilt12_dbdata
%         .ofilt3_dbdata
%         .oaspl



Pref = 20E-6; %[Pa]
testdata = struct('dbdata',[],'Pdata',[],'Pdata_t',[],'testmag',[],'tvec',[],'wavdata',[],'fs',[],'fvec',[]);
testprefix = [testdate '_test_' testletter ' - 01 Start - '];
% Afilt = WeightingFilter('A-weighting',48000);
% read the test files
for micnum = micnums
    fname = [testprefix num2str(micnum) '.wav'];
    if isfile(fname)
        [testdata(micnum).wavdata, testdata(micnum).fs] = audioread(fname);
        testdata(micnum).tvec = 0: 1/testdata(micnum).fs: (length(testdata(micnum).wavdata)-1)/testdata(micnum).fs;
        [testdata(micnum).fvec, testdata(micnum).testmag, ~, ~] = ffind_dft(testdata(micnum).tvec, testdata(micnum).wavdata, 0);
        
        testdata(micnum).Pdata = testdata(micnum).testmag * caldata(micnum).calfactor /2; %PRESSURE DOUBLING AT RIGID SURFACE
        testdata(micnum).Pdata_t = testdata(micnum).wavdata * caldata(micnum).calfactor /2; %PRESSURE DOUBLING AT RIGID SURFACE
        
        [testdata(micnum).ofilt12_fvec,testdata(micnum).ofilt12_Pdata] = OctaveFilter(testdata(micnum).fvec,testdata(micnum).Pdata,12);
        [testdata(micnum).ofilt3_fvec,testdata(micnum).ofilt3_Pdata] = OctaveFilter(testdata(micnum).fvec,testdata(micnum).Pdata,3);
        
        testdata(micnum).dbdata = 20*log10(testdata(micnum).Pdata / Pref);
%         A = Afilt(testdata(micnum).fvec);
%         testdata(micnum).dbAdata = testdata(micnum).dbdata + A;
        testdata(micnum).ofilt12_dbdata = 20*log10(testdata(micnum).ofilt12_Pdata / Pref); 
        testdata(micnum).ofilt3_dbdata = 20*log10(testdata(micnum).ofilt3_Pdata / Pref); 
        
        testdata(micnum).oaspl = OverallSPL(testdata(micnum).Pdata); 
%         testdata(micnum).oasplA = OverallSPL(Pref * 10^(testdata(micnum).dbAbdata / 20));

        
    end
end

if (plots)
    %TIME DOMAIN
    figure(1)
    for micnum = micnums
        subplot(length(micnums),1,micnum)
        plot(testdata(micnum).tvec, testdata(micnum).wavdata)
        axis([0 1 -0.5 0.5]);
        legend(['Mic ' num2str(micnum)]);
    end
    xlabel('Time, s')
    
    
    %FREQ DOMAIN
    figure(11)
    for micnum = micnums
        subplot(length(micnums),1,micnum)
        semilogx(testdata(micnum).fvec, testdata(micnum).dbdata)
        xlim([10^1 10^4]);
        legend(['Mic ' num2str(micnum)]);
    end
    xlabel('Frequency, Hz')
    
    
    figure(13)
    for micnum = micnums
        subplot(length(minnums),1,micnum)
        semilogx(testdata(micnum).fvec, testdata(micnum).dbAdata)
        xlim([10^1 10^4]);
        legend(['Mic ' num2str(micnum)]);
    end
    xlabel('Frequency, Hz')
    

end
