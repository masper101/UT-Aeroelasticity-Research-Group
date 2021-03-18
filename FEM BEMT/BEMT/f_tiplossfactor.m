function F = f_tiplossfactor(Nb, r, phi)
%PRANDTL TOP LOSS FACOTR

f = Nb/2 *(1-r) ./r ./ phi; 

F = (2/pi) .* acos(exp(-f));
% F(end) = 0;

