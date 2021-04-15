% atmospheric attenuation copied / translated from python library
% ISO 9613-1:1993
% ===============
%
% ISO 9613-1:1993 specifies an analytical method of calculating the attenuation of sound
% as a result of atmospheric absorption for a variety of meteorological conditions.
function [alpha] = iso1993(frequency, temp, press, relhum)
reftemp = 293.15;
refpress = 101.325;
triptemp = 273.16;

satpress = saturation_pressure(temp,refpress,triptemp);
molwater = molar_concentration_water_vapour(relhum,satpress,press);
relaxoxy = relaxation_frequency_oxygen(press,molwater,refpress);
relaxnit = relaxation_frequency_nitrogen(press,temp,molwater,refpress,reftemp);
alpha = attenuation_coefficient(press,temp,refpress,reftemp,relaxnit,relaxoxy,frequency);

end

function [sos] = soundspeed(temperature, reference_temperature)
%  Speed of sound
sos =  343.2 * sqrt(temperature / reference_temperature);
end

function [psat] = saturation_pressure(temperature, reference_pressure, triple_temperature)
% Saturation vapour pressure
psat =  reference_pressure * 10.0.^(-6.8346 * (triple_temperature / temperature).^(1.261) + 4.6151);

end

function [h] = molar_concentration_water_vapour(relative_humidity, saturation_pressure, pressure)

%Molar concentration of water vapour
h =  relative_humidity * saturation_pressure / pressure;
end


function [fo] = relaxation_frequency_oxygen(pressure, h, reference_pressure)

%Relaxation frequency of oxygen

% inputs:
%Ambient pressure
% reference_pressure
% h: Molar concentration of water vapour

fo =  pressure / reference_pressure * (24.0 + 4.04 * 10.0^4.0 * h * (0.02 + h) / (0.391 + h));
end

function [fn] = relaxation_frequency_nitrogen(pressure, temperature, h, reference_pressure,reference_temperature)

% Relaxation frequency of nitrogen
% inputs
%   pressure: Ambient pressure :math:`p_a`
%   temperature: Ambient temperature :math:`T`
%   h: Molar concentration of water vapour :math:`h`
%   reference_pressure: Reference pressure :math:`p_{ref}`
%  reference_temperature: Reference temperature :math:`T_{ref}`

fn =  pressure / reference_pressure * (temperature / reference_temperature)^(-0.5) * (...
    9.0 + 280.0 * h * exp(-4.170 * ((temperature / reference_temperature)^(-1.0 / 3.0) - 1.0)));

end

function [a] =  attenuation_coefficient(pressure, temperature, reference_pressure, reference_temperature, relaxation_frequency_nitrogen, relaxation_frequency_oxygen, frequency)

%Attenuation coefficient :math:`\\alpha` describing atmospheric absorption in dB/m for the specified ``frequency``.

% pressure: Ambient pressure :math:`T`
%temperature: Ambient temperature :math:`T`
% reference_pressure: Reference pressure :math:`p_{ref}`
% reference_temperature: Reference temperature :math:`T_{ref}`
% relaxation_frequency_nitrogen: Relaxation frequency of nitrogen :math:`f_{r,N}`.
% relaxation_frequency_oxygen: Relaxation frequency of oxygen :math:`f_{r,O}`.
% frequency: Frequencies to calculate :math:`\\alpha` for.

a =  8.686 * frequency.^2.0 .* (...
    (1.84 * 10.0^(-11.0) * (reference_pressure / pressure) * (temperature / reference_temperature)^...
    (0.5)) + (temperature / reference_temperature)^(-2.5) ...
     * (0.01275 * exp(-2239.1 / temperature) * (relaxation_frequency_oxygen +...
    (frequency.^2.0 ./ relaxation_frequency_oxygen)).^(-1.0) ...
     + 0.1068 * exp(-3352.0 / temperature) *...
    (relaxation_frequency_nitrogen + (frequency.^2.0 / relaxation_frequency_nitrogen)).^(-1.0)));
end