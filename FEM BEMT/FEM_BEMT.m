% BEMT + FEM
clear; clc; %close all;
addpath('/Users/chloe/Library/Mobile Documents/com~apple~CloudDocs/Grad/Research/Code/FEM/Figs')
addpath('/Users/chloe/Library/Mobile Documents/com~apple~CloudDocs/Grad/Research/Code/BEMT')

%% INPUTS
N_BEMT = 60;
N_FEM = N_BEMT;

% BEMT INPUTS
AF = 'VR12';
R = 1.108;
c = 80/1000;
th_0 = 8;
th_tw = 0/R;
Nb = 2;
plots = false;
OMEGA = 1200 / 60 * 2*pi;   %rad/s
rho = 1.1912;
A = pi*R^2;
cutout = 0.1876;

x_blade = 0:R/N_FEM:R;
EI = load('EIyy.csv');
EI = interp1(EI(:,1)*R, EI(:,2)*4.44822*0.092903, x_blade,'pchip');    %N-m^2
m = load('m_L.csv');
m = interp1(m(:,1)*R, m(:,2)*47.8803,x_blade,'pchip');                %kg/m

%% BEMT
[r,dr,dCT,CT,sig,CP,FM] = f_BEMT(R,c,cutout,th_0,th_tw,Nb,N,plots,OMEGA,AF);
dL = dCT *rho*A*(OMEGA*R)^2 / Nb;                               %dL begins at node 2

%% FEM
BC = 'cantilever';
[x,K,V,wn] = f_FEM(BC, N_FEM, R, cutout, OMEGA, m, EI);  %K begins at node 2 (from BC condition)

if (true)
    figure(3)
    hold on
    h = plot(x, V(:,1:3),'linewidth',1.2);
%     legend(h, {'1st Mode' ,'2nd Mode', '3rd Mode'},'location','northwest')
    ylabel('Displacement, m')
    xlabel('Radial Location, m')
    title('Cantilever Beam - UT')
    set(gca, 'Fontsize',16)
end

%% Forcing
F = zeros(length(K),1);
F(1:2:end) = dL;

d = K\F;
if (true)
    figure(4)
    subplot(2,1,1)
    plot(x,[0;F(1:2:end)],'.-','linewidth',1.2)
    ylabel('dF, N/m')
    set(gca, 'Fontsize',16)
    grid on
    xlim([0,R])
    
    subplot(2,1,2)
    hold on
    plot(x, [0;d(1:2:end)],'.-','linewidth',1.2)
    ylabel('Displacement, m')
    xlabel('Radial Location, m')
    set(gca, 'Fontsize',16)
    sgtitle('Cantilever Beam - UT')
    grid on
    xlim([0,R])
end

