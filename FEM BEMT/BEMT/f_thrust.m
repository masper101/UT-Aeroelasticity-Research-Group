function [dCT, CT] = f_thrust(r, dr, Cl, sig)
%TOTAL THRUST COEFFICIENT

dCT = f_incremental_thrust(r, dr, Cl, sig);

CT = sum(dCT);