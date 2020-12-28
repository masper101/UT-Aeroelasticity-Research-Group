function [dCPi , CPi, kappa] = f_ind_power(lam, dCT)

dCPi = lam.*dCT; 
CPi = sum(dCPi); 
CT = sum(dCT);
kappa = CPi / (CT^(3/2)/sqrt(2)); 