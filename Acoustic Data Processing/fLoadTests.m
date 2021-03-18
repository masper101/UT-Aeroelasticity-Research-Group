function fLoadTests(directory)

pdir = pwd;
cd(directory); 

files = dir('*.wav');
filenames = {files(:).name}';
dates = unique(extractBefore(filenames,'_'));

calletters = unique(extractBetween(filenames(contains(filenames,'cal')),'test_','_cal'));
tests = unique(extractBetween(filenames(~contains(filenames,'cal')),'test_',' -'));
testletters = unique(extractBefore(tests(contains(tests,testdate),'_'));

fprintf('\n\t%s', 'Loaded test dates are [YYMMDD] : ')
fprintf('%s ',dates{:});
fprintf('\n\t')
testdate = input('Test Date [YYMMDD] : ', 's');