function [sig, sig_r] = f_solidity(R,c,Nb)

q1 = R*c*Nb;
q2 = pi*R^2;

sig_r = q1./q2;

dr = 1./length(c);

sig = sum(sig_r)*dr;
