function [s_ele,K,M] = f_GlobalMatrices(N_ele, R, cutout, OMEGA, m, EI)
% GET GLOBAL MATRICES OF BEAM
% C JOHNSON 12/18/20

% INPUTS
%     N_ele           number of FEM elements
%     R               radius or length of total beam
%     cutout          location where cantilever begins
%     OMEGA           rotational velocity (rad/s)
%     m               mass/length distribution of entire length of blade
%     EI              blade flapping EI distribution of entire length of blade

% OUTPUTS
%     s_ele           Inboard location of each elements + length of blade
%     K               Global stiffness matrix
%     M               Global mass matrix


%% FEM PARAMETERS
L_ele = (R-R*cutout)/N_ele;             % Length of each element
s_ele = R*cutout:L_ele:R;               % Inboard location of each elements + length of blade
N_dofs = (N_ele+1) *2;                  % Number of degrees of freedom (2 at each node)

if length(m)==1
    m = m * ones(N_ele,1);                          % constant m along blade span
end
if length(EI)==1
    EI = EI * ones(N_ele,1);                        % constant EI along blade span
end

%% ELEMENTAL MATRICES
L = L_ele;

Me = [(13*L)/35,        (11*L^2)/210,       (9*L)/70,   	-(13*L^2)/420
    (11*L^2)/210,     L^3/105,            (13*L^2)/420,	-L^3/140
    (9*L)/70,         (13*L^2)/420,       (13*L)/35,      -(11*L^2)/210
    -(13*L^2)/420,   -L^3/140,           -(11*L^2)/210,  L^3/105];

Ke = [12/L^3,	6/L^2,	-12/L^3,	6/L^2
    6/L^2,	4/L,	-6/L^2,     2/L
    -12/L^3,	-6/L^2,	12/L^3,     -6/L^2
    6/L^2,    2/L,	-6/L^2,     4/L];

T1 = [6/(5*L),	1/10,       -6/(5*L),	1/10
    1/10,     (2*L)/15,	-1/10,      -L/30
    -6/(5*L),	-1/10,      6/(5*L),	-1/10
    1/10,     -L/30,      -1/10,      (2*L)/15];

%% GLOBAL MATRICES
M = zeros(N_dofs);
K = zeros(N_dofs);
T1_sum = zeros(N_ele,1);

for i = 1:N_ele
    loc = 2*i - 1;
    
    % MASS MATRIX
    M(loc:loc+3, loc:loc+3) = M(loc:loc+3, loc:loc+3) + Me*m(i);
    
    % STRUCTURAL STIFFNESS MATRIX
    K(loc:loc+3, loc:loc+3) = K(loc:loc+3, loc:loc+3) + Ke*EI(i);
    
    % CENTRIFUGAL STIFFNESS
    % T1
    for j = i:N_ele
        T1_sum(i) = T1_sum(i) + (s_ele(j+1)^2 - s_ele(j)^2);
    end
    yi = s_ele(i);
    % T2
    T2 = [(12*L)/35 + (6*yi)/5,     (L*(5*L + 14*yi))/70,       -(12*L)/35 - (6*yi)/5,	-L^2/35
        (L*(5*L + 14*yi))/70,     (L^2*(2*L + 7*yi))/105,     -(L*(5*L + 14*yi))/70,	-(L^2*(3*L + 7*yi))/210
        -(12*L)/35 - (6*yi)/5,	-(L*(5*L + 14*yi))/70,      (12*L)/35 + (6*yi)/5,	L^2/35
        -L^2/35,                  -(L^2*(3*L + 7*yi))/210,	L^2/35,                 (L^2*(3*L + 7*yi))/35];
    
    % TOTAL STIFFNESS MATRIX
    K(loc:loc+3, loc:loc+3) = K(loc:loc+3, loc:loc+3) ...
        + T1*T1_sum(i)*(OMEGA^2/2*m(i)) + T2*(-OMEGA^2/2)*m(i);
    
end

