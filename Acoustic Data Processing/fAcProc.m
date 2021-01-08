function [testnames, testdata, caldata] = fAcProc(directory)
% READ AND CONVERT TEST FILES INTO DB VALUES, PLOT EACH MIC
% CMJOHNSON 05/15/2020
% INPUTS
%     caldata                 -> get calibration factors
%     testdate
%     testletter
%     plots = true or false
%     Pdoubling = true or false
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
%         .Pdata_t [Pa]       -> pressure in time domain (240000 x 1)
%
%         .ofilt12_fvec
%         .ofilt12_Pdata
%         .ofilt12_dbdata
%
%         .ofilt3_fvec
%         .ofilt3_Pdata
%         .ofilt3_dbdata
%
%         .oaspl
%         .dbdataA
%         .oasplA
pdir = pwd;
cd(directory);

%% INPUTS
%Pdoubling
Pdoubling = input('Pressure doubling [y n] ? ', 's');
if (Pdoubling == 'y')
    doubling_factor = 1/2; %PRESSURE DOUBLING AT RIGID SURFACE
else
    doubling_factor = 1;
end

%file names
files = dir('*.wav');
filenames = {files(:).name}';

%choose dates
fprintf('\n%s\n','Test file: ')
dates = unique(extractBefore(filenames,'_'));
fprintf('\n\t%s', 'Loaded test dates are [YYMMDD] : ')
fprintf('%s ',dates{:});
fprintf('\n\t')
testdates = input('Test Date [YYMMDD] : ', 's');
testdates = split(testdates, ' ');

%choose tests
for ii = 1:length(testdates)
    loc = (contains(filenames,'cal'))&(contains(filenames,testdates{ii}));
    caltests = unique(extractBetween(filenames(loc),'test_','_cal'));
    
    loc = (~contains(filenames,'cal'))&(contains(filenames,testdates{ii}));
    tests = unique(extractBetween(filenames(loc),'test_',' -'));
    letters = unique(extractBefore(tests,'_'));
    
    fprintf('\n\t%s', 'Test Date : ')
    fprintf('%s', testdates{ii})
    fprintf('\n\t\t%s', 'Loaded tests are : ')
    fprintf('%s ',letters{:});
    fprintf('\n\t\t')
    testletters{ii} = input('Tests to process : ', 's');
    testletters{ii} = split(testletters{ii}, ' ');
    
    %choose test numbers
    for jj = 1:length(testletters{ii})
        numbers = unique(extractAfter(tests(contains(tests,testletters{ii}{jj})),'_'));
        fprintf('\n\t\t%s', 'Test : ')
        fprintf('%s', testletters{ii}{jj})
        
        fprintf('\n\t\t\t%s', 'Loaded calibration tests are : ')
        fprintf('%s ',caltests{:});
        fprintf('\n\t\t\t')
        calletters{ii}{jj} = input('Calibration test : ', 's');
        calletters{ii}{jj} = split(calletters{ii}{jj}, ' ');
        
        fprintf('\n\t\t\t%s', 'Loaded test numbers are : ')
        fprintf('%s ',numbers{:});
        fprintf('\n\t\t\t')
        testnumbers{ii}{jj} = input('Test numbers to process : ', 's');
        testnumbers{ii}{jj} = split(testnumbers{ii}{jj}, ' ');
    end
end


cnt1=0;
for ii = 1:length(testdates)
    for jj = 1:length(testletters{ii})
        for kk = 1:length(testnumbers{ii}{jj})
            if strcmp(testnumbers{ii}{jj}{kk}, 'all')
                numbers = unique(extractAfter(tests(contains(tests,testletters{ii}{jj})),'_'));
                for ll = 1:length(numbers)    
                    cnt1=cnt1+1;
                    testprefix{cnt1} = [testdates{ii} '_test_' testletters{ii}{jj} '_' numbers{ll} ' - 01 Start - '];
                    calprefix{cnt1} = [testdates{ii} '_test_' calletters{ii}{jj}{1} '_cal - 01 Start - '];
                end
            else
                cnt1=cnt1+1;
                testprefix{cnt1} = [testdates{ii} '_test_' testletters{ii}{jj} '_' testnumbers{ii}{jj}{kk} ' - 01 Start - '];
                calprefix{cnt1} = [testdates{ii} '_test_' calletters{ii}{jj}{1} '_cal - 01 Start - '];
            end
        end
    end
end

%% read the test files
for k = 1:length(testprefix)
    calname = extractBefore(calprefix{k}, ' -');
    fprintf('\n%s\n',['Calibrating microphones. Calibration file: ',calname])
    caldata{k} = fCalProc2(calprefix{k});
    
    testdata{k} = struct('name',[],'oaspl',[],'oasplA',[],'dbAdata',[],'dbdata',[],'Pdata',[],'Pdata_t',[],'testmag',[],'tvec',[],'wavdata',[],'fs',[],'fvec',[],'ofilt12_fvec',[],'ofilt12_Pdata',[],'ofilt12_dbdata',[],'ofilt3_fvec',[],'ofilt3_Pdata',[],'ofilt3_dbdata',[]);
    testdata{k}.name = extractBefore(testprefix{k},' -');  
    testnames{k} = extractBefore(testprefix{k},' -');  
    fprintf('\n%s\n',['Processing Data. Data file: ', testdata{k}.name])
    for micnum = 1:16
        fname = [testprefix{k} num2str(micnum) '.wav'];
        if isfile(fname)
            fprintf('\t%s',['- Mic ', num2str(micnum),' ... '])
            [testdata{k}(micnum).wavdata, testdata{k}(micnum).fs] = audioread(fname);
            testdata{k}(micnum).tvec = 0: 1/testdata{k}(micnum).fs: (length(testdata{k}(micnum).wavdata)-1)/testdata{k}(micnum).fs;
            [testdata{k}(micnum).fvec, testdata{k}(micnum).testmag, ~, ~] = ffind_dft(testdata{k}(micnum).tvec, testdata{k}(micnum).wavdata, 0);
            
            testdata{k}(micnum).Pdata = testdata{k}(micnum).testmag * caldata{k}(micnum).calfactor * doubling_factor;
            testdata{k}(micnum).Pdata_t = testdata{k}(micnum).wavdata * caldata{k}(micnum).calfactor * doubling_factor;
            
            [testdata{k}(micnum).ofilt12_fvec,testdata{k}(micnum).ofilt12_Pdata,testdata{k}(micnum).ofilt3_fvec,testdata{k}(micnum).ofilt3_Pdata,...
                testdata{k}(micnum).dbdata,testdata{k}(micnum).dbAdata,testdata{k}(micnum).ofilt12_dbdata,testdata{k}(micnum).ofilt3_dbdata,...
                testdata{k}(micnum).ofilt12_dbAdata,testdata{k}(micnum).ofilt3_dbAdata, testdata{k}(micnum).oaspl,testdata{k}(micnum).oasplA] = ...
                fPostProcAc(testdata{k}(micnum).tvec,testdata{k}(micnum).fvec,testdata{k}(micnum).Pdata_t,testdata{k}(micnum).Pdata);
            
            %         [testdata{k}(micnum).ofilt12_fvec,testdata{k}(micnum).ofilt12_Pdata] = fOctaveFilter(testdata{k}(micnum).fvec,testdata{k}(micnum).Pdata,12);
            %         [testdata{k}(micnum).ofilt3_fvec,testdata{k}(micnum).ofilt3_Pdata] = fOctaveFilter(testdata{k}(micnum).fvec,testdata{k}(micnum).Pdata,3);
            %
            %         testdata{k}(micnum).dbdata = 20*log10(testdata{k}(micnum).Pdata / Pref);
            %         A = fAfilt(testdata{k}(micnum).fvec);
            %         testdata{k}(micnum).dbAdata = testdata{k}(micnum).dbdata + A';
            %
            %         testdata{k}(micnum).ofilt12_dbdata = 20*log10(testdata{k}(micnum).ofilt12_Pdata / Pref);
            %         testdata{k}(micnum).ofilt3_dbdata = 20*log10(testdata{k}(micnum).ofilt3_Pdata / Pref);
            %
            %         testdata{k}(micnum).oaspl = fOverallSPL_time(testdata{k}(micnum).Pdata_t, testdata{k}(micnum).tvec);
            %         testdata{k}(micnum).oasplA = fOverallSPL_freq(Pref * 10.^(testdata{k}(micnum).dbAdata / 20));
            
            fprintf('%s\n',['OASPL = ',num2str(testdata{k}(micnum).oaspl)])
        end
    end
    cd(pdir);
    fprintf('\n\t')
%     worv = input('Visualize (v) test data ? ', 's');
worv = 'n';
    switch worv
        case 'v'
            %FREQ DOMAIN
            figure(11)
            for micnum = 1:8
                subplot(8,1,micnum)
                semilogx(testdata{k}(micnum).fvec, testdata{k}(micnum).dbdata,testdata{k}(micnum).fvec, testdata{k}(micnum).dbAdata)
                xlim([10^1 10^4]);
                legend(['Mic ' num2str(micnum)]);
            end
            xlabel('Frequency, Hz')
            sgtitle([testdate '_test_' testletter])
            
            figure(12)
            for micnum = 9:16
                subplot(8,1,micnum-8)
                semilogx(testdata{k}(micnum).fvec, testdata{k}(micnum).dbdata,testdata{k}(micnum).fvec, testdata{k}(micnum).dbAdata)
                xlim([10^1 10^4]);
                legend(['Mic ' num2str(micnum)]);
            end
            xlabel('Frequency, Hz')
            sgtitle([testdate ' test ' testletter])
            
        otherwise
    end
end
end