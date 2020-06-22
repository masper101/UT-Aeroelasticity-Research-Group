function [ofilt12_fvec,ofilt12_Pdata,ofilt3_fvec,ofilt3_Pdata,dbdata,dbAdata,ofilt12_dbdata,ofilt3_dbdata,oaspl,oasplA] = fPostProcAc(tvec,fvec,Pdata_t,Pdata)
% POST PROCESING ACOUSTIC DATA
% CMJOHNSON 06/14/20
Pref = 20E-6; %[Pa]

[ofilt12_fvec,ofilt12_Pdata] = fOctaveFilter(fvec,Pdata,12);
[ofilt3_fvec,ofilt3_Pdata] = fOctaveFilter(fvec,Pdata,3);

dbdata = 20*log10(Pdata / Pref);
A = fAfilt(fvec);
dbAdata = dbdata + A';

ofilt12_dbdata = 20*log10(ofilt12_Pdata / Pref);
ofilt3_dbdata = 20*log10(ofilt3_Pdata / Pref);

oaspl = fOverallSPL_time(Pdata_t, tvec);
oasplA = fOverallSPL_freq(Pref * 10.^(dbAdata / 20));

