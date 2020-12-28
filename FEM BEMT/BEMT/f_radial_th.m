function th = f_radial_th(r, th_0, th_tw)
%RADIAL ANGLE OF ATTACK FOR TWISTED ROTOR, col IN DEG

th_0 = th_0*pi/180;


th = th_0 * ones(size(r)) + r*th_tw*pi/180;