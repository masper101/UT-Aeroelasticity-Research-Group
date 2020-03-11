function [xfilt,yfilt] = OctaveFilter(fv,fy,octband)
% AVERAGES DATA OVER FRACTIONAL OCTAVE BANDS 
%
% DLWYLIE 03/03/2020
% CMJOHNSON EDITS 03/04/2020
%
% INPUTS
%   fv                  -> unfiltered frequency vector (testdata(micnum).fvec)
%   fy                  -> unfiltered pressure vector (testdata(micnum).Pdata)
%   octband             -> octave band to average over (1/12th -> 12), (1/3rd-> 3)
%
% OUTPUTS
%   xfilt               -> filtered frequency vector
%   yfilt               -> filtered pressure vector

one_octave = [10 22 44 88 177 355 710 1420 2840 5680 10000];
one_octave = [10 20 40 80 160 320 640 1280 2560 3120 6240 12480 24960];
band = [];
% getting octave band boundaries
for i = 1:length(one_octave)-1
    X = linspace(one_octave(i),one_octave(i+1),octband+1);
    band = [band X];
    for ii = 1:length(band)-1
        if ii>=length(band)
            break
        elseif band(ii+1) - band(ii) ==0        %% ditching repeat values
            band(ii) = [];
        end
    end
end
% getting vector of average in each band
for q = 1:length(band)-1
    [~,loc1] = min(abs(fv - band(q)));
    [~,loc2] = min(abs(fv - band(q + 1)));
    xfilt(q) = (band(q + 1) + band(q))/2;
    yfilt(q) = mean(fy(loc1:loc2));
end
end

