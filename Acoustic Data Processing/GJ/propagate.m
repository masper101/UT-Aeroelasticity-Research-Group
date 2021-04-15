% test attunuation functions
function [spec_far] = propagate(freq,specdB,dist,dist_fac,temp,press,hum)
% Inputs:
% freq - frequency (vector) in Hz
% specdB - spectrum in dB
% dist - distance in m
% dist_fac - Rfar/Rspec multiple of original distance from source
% temp = 20; % temp in c
% press = 101325; %press in Pa
% hum = 30; % relative humidity in percent

[a] = iso1993(freq, temp+273.15, press/1000, hum); % attenuation coeff dB/m
TL = a*dist; % transmission loss

spec_dB = specdB - TL; % subtract transmission loss (atmosphere attenuation)

spec_far = spec_dB - 20*log10(dist_fac); % spherical spreading

end




