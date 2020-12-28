function [r,dr,dCT,CT,sig,CP,FM] = f_BEMT(R,c,cutout,th_0,th_tw,Nb,N,plots,OMEGA,AF)
%RUN BEMT ANALYSIS
%CHLOE JOHNSON SPRING 2020

% INPUTS
%     R               radius, m
%     c               chord, m
%     cutout          R to omit
%     th_0            pitch anlge, deg
%     th_tw           pitch angle twist, deg
%     Nb              number of blades
%     N               number of radial elements
%     plots           true/false if to plot 
%     OMEGA           rotation speed, rad/s
%     AF              aifoil, options: VR12, VR12_schmaus, NACA0012

% OUTPUTS
%     r               non-dimensional radial vector
%     dr              non-dimensional element size
%     dCT             incremental thrust coefficient
%     CT              thrust coefficient
%     sig             solidity
%     CP              power coefficient
%     FM              figure of merit

%% UT ROTOR INPUTS     
% R = 1.108;        
% c = 80/1000;      
% cutout = 0.1;    
% th_0 = 8;         
% th_tw = 0/R;      
% Nb = 2;           
% N = 60;           
% plots = false; 
% OMEGA = 1200*2*pi/60;
% AF = 'VR12'; 

%% SET UP GEOMETRY  
[sig, y, r, dr, th] = f_rotorparameters(R, c, Nb, th_0, th_tw, N,cutout);

%% CALCULATE WITHOUT TIPLOSS
Cla = 2*pi;
lam = f_inflow(r, th, Cla, sig, 1); %TIP LOSS FACTOR, F=1
Cl = f_lift(Cla, th, lam, r, R, OMEGA, AF);
[dCT, CT] = f_thrust(r, dr, Cl, sig);

%% CALCULATE WITH TIPLOSS
lam = f_prandtltiploss(Nb, r, lam, th, Cla, sig);
Cl = f_lift(Cla, th, lam, r, R, OMEGA, AF);
[dCT, CT] = f_thrust(r, dr, Cl, sig);
[CP, FM] = f_power(R, r, dr, th, lam, sig, OMEGA, AF, dCT, CT);

%% PLOT
if (plots)
    figure(1)
    hold on
    plot(r,lam)
    title('\lambda')
    
    figure(2)
    hold on
    plot(r, Cl)
    title('C_l')
    
    figure(3)
    hold on
    plot(r, dCT/dr)
    hold on
    title('dC_T / dr')
    
    % plot(r, (th-lam./r)*180/pi,'o')    %alpha
    % plot(r, (lam/r)*180/pi,'o')        %phi
end

