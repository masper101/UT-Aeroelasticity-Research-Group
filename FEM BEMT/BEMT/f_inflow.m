function lam = f_inflow(r, th, Cla, sig, F)
%RADIAL INFLOW

quant = sqrt(1 + 32*F/sig./Cla .* th .*r) - 1;
lam = sig * Cla/16./F .* quant;
