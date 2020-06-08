function testdata = TestProc_SaveMem(testdate, testletter, caldata)
% READ AND CONVERT TEST FILES INTO DB VALUES, PLOT EACH MIC
% CMJOHNSON 03/25/2020
% INPUTS
%     caldata                 -> get calibration factors
%     testdate
%     testletter
% OUTPUTS
%     testdata
%         .fvec
%         .dbdata
%         .dbAdata
%         .oaspl
%         .oasplA


Pref = 20E-6; %[Pa]
testdata = struct('oaspl',[],'oasplA',[],'dbdata',[],'dbAdata',[],'fvec',[]);
testprefix = [testdate '_test_' testletter ' - 01 Start - '];

% read the test files
for micnum = 1:16
    fname = [testprefix num2str(micnum) '.wav'];
    if isfile(fname)
        [wavdata, fs] = audioread(fname);
        tvec = 0: 1/fs: (length(wavdata)-1)/fs;
        [testdata(micnum).fvec, testmag, ~, ~] = ffind_dft(tvec, wavdata, 0);
        
        Pdata = testmag * caldata(micnum).calfactor /2; %PRESSURE DOUBLING AT RIGID SURFACE
        
        testdata(micnum).dbdata = 20*log10(Pdata / Pref);
        A = Afilt(testdata(micnum).fvec);
        testdata(micnum).dbAdata = testdata(micnum).dbdata + A';
        
        testdata(micnum).oaspl = OverallSPL(Pdata); 
        testdata(micnum).oasplA = OverallSPL(Pref * 10.^(testdata(micnum).dbAdata / 20));

        
    end
end

