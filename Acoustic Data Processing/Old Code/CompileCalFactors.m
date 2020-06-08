function CompileCalFactors(caldata,filename,dir)
% COMPILES CALIBRATION FACTORS INTO EXCEL SHEET [Pa / .WAV UNIT]
%
% INPUTS
%     caldata
%     filename
%     dir             -> where to save filename to
%
% OUTPUTS
%     XLSX FILE

M = {};
M(:,1) = {'Mic Number','Calibration Factor [Pa/.wav unit]'};

A = [];
A(1,1:16) = [1:1:16];
A(2,1:16) = [caldata.calfactor];

A = array2table(A);

M = cell2table(M);
M = [M,A];
cd(dir)
writetable(M,filename,'WriteVariableNames',false);