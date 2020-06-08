function [xfilt,yfilt] = fOctaveFilter(fv,fy,N)
% AVERAGES DATA OVER FRACTIONAL OCTAVE BANDS 
%
% DLWYLIE 03/03/2020
% CMJOHNSON EDITS 03/04/2020
%
% INPUTS
%   fv                  -> unfiltered frequency vector (testdata(micnum).fvec)
%   fy                  -> unfiltered pressure vector (testdata(micnum).Pdata)
%   N                   -> octave band to average over (1/12th -> 12), (1/3rd-> 3)
%
% OUTPUTS
%   xfilt               -> filtered frequency vector
%   yfilt               -> filtered pressure vector


%CREATE CENTER FREQUENCIES AND UPPER/LOWER FREQUENCIES
oct =1000;
% a = 2^(1/N); %BASE 2
a = 10^(2/(10*N)); %BASE 10

f_c = [oct];
% f_a = [oct / 2^(1/(2*N))]; %BASE 2
f_a = [oct / 10^(2/(10*2*N))]; %BASE 10
while oct >= 1 
    oct = oct / a;
    f_c = [oct f_c];
    
    oct_a = f_a(1) / a;
    f_a = [oct_a f_a];  
end

while oct<= 24000
    oct = f_c(end) * a;
    f_c = [f_c oct];
    
    oct_a = f_a(end) * a; 
    f_a = [f_a oct_a];
end
oct_a = f_a(end) * a;
f_a = [f_a oct_a];


%AVERGAE BETWEEN UPPER AND LOWER FREQUENCIES
xfilt = f_c;
yfilt = ones(size(f_c))';
for n = 1:length(f_a) - 1
    [~,loc_f_a] = min(abs(fv - f_a(n)));
    [~,loc_f_b] = min(abs(fv - f_a(n+1)));
    yfilt(n) = sqrt(nansum(fy(loc_f_a:loc_f_b).^2));
end

