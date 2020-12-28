function [sig, y, r, dr, th] = f_rotorparameters(R, c, Nb, th_0, th_tw, N,cutout)

sig = f_solidity(R, c, Nb);

[y, r, dr] = f_radial_elements(R, N, cutout);

th = f_radial_th(r, th_0, th_tw);