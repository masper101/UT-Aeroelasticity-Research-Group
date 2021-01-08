function lam = f_prandtltiploss(Nb, r, lam, th, Cla, sig)
%ITERATE THROUGH TIPLOSS FACTOR AND INFLOW UNTIL CONVERGENCE

F_old = ones(size(r));
err = 1;
count = 0;
while err>0.01
    phi = lam ./r;
    F = f_tiplossfactor(Nb, r, phi);
    lam = f_inflow(r, th, Cla, sig, F);
    err = abs(sum(F) - sum(F_old));
    F_old = F;
    count = count+1;
end