function dCT = f_incremental_thrust(r, dr, Cl, sig)
%RADIAL THRUST COEFFICIENT

dCT = sig/2 * Cl .* (r.^2) .*dr;
