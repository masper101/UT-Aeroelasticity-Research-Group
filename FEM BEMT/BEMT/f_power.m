function [CP, FM] = f_power(R, r, dr, th, lam, sig, OMEGA, AF, dCT, CT)

CP_ideal = CT^(3/2) / sqrt(2);
[dCPi , CPi, kappa] = f_ind_power(lam, dCT);
CP_ideal = CT^(3/2) / sqrt(2);
[dCP0, CP0] = f_profile_power(R, r, dr, th, lam, sig, OMEGA, AF);
CP = CP0 + CPi;
FM = CP_ideal / (CP);