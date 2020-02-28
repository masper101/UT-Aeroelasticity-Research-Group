function [u,t] = Newmark_beta(M,C,K,F,T,dt)
%Newmark-Beta integration scheme
% This function implements an integration scheme to solve a multi-degree of
% freedom system in the time-domain. Initial conditions are set to zero per
% default but can be changed in the code
% 
% Author : Marc Eitner
% Created: January 2020
%
% Input:  
%           M : mass matrix [dof x dof]
%           C : damping matrix [dof x dof]
%           K : stiffness matrix [dof x dof]
%           F : forcing matrix [dof x N]
%           T : maximum time in seconds
%           dt: timestep for integration in seconds
%
% Output:
%           u : deformation matrix [N x dof]
%           t : time vector [N x 1]
%
% 
% Example:
% Define a 12-dof system and all other inputs:
% M = eye(12); M(1,1) = 2; M(12,12) = 3; % mass matrix
% K = zeros(12); % stiffness matrix
% for i = 1:12
%     K(i,i) = 2;
% end
% for i = 1:11
%     K(i,i+1) = -1;
% end
% for i = 2:12
%     K(i,i-1) = -1;
% end
% K = K*2000;
% C = M*3; % damping matrix
% %Define time-values
% T = 10; 
% dt = 0.001;
% t = dt:dt:T; % time vector
% N = length(t);
% F = randn(12,N);
%now run the code [u,t] = Newmark_beta(M,C,K,F,T,dt) 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dof = size(M,1);

% check correct dimension of forcing matrix
if size(F,1) > size(F,2)
    F = F';
end

% check stability condition of scheme
[~,lambda] = eig(K,M,'vector');
if dt > 0.1*2*pi/sqrt(max(lambda))
    dt = 0.1*2*pi/sqrt(max(lambda));
    disp(['Warning! Chosen time-step too large, default time-step of ',num2str(dt),' s was used instead.'])  
end

t = dt:dt:T; % time vector
N = length(t);

% placeholders
u = zeros(dof,N);
u_dot = zeros(dof,N);
u_ddot = zeros(dof,N);

% initial conditions
% u(3,1) = 4; % this would set the initial displacement of dof 3 to 1 [m]
% u_dot(2,1) = 3; % this would set the initial velocity of dof 2 to 3 [m/s]
u_ddot(:,1) = inv(M)*(F(:,1)-(K*u(:,1))-(C*u_dot(:,1)));

% Define constants
beta = 0.5;
alpha = 0.25*(0.5+beta)^2;
a0 = 1/(alpha*dt^2);
a1 = beta/(alpha*dt);
a2 = 1/(alpha*dt);
a3 = 1/(2*alpha)-1;
a4 = beta/alpha-1;
a5 = dt/2*(beta/alpha-2);
a6 = dt*(1-beta);
a7 = beta*dt;
K_eff = K+a0*M+a1*C;

% loop over each time-step
for i = 1:N-1
% effective force
F_eff = F(:,i)+M*(a0*u(:,i)+a2*u_dot(:,i)+a3*u_ddot(:,i))+C*(a1*u(:,i)+a4*u_dot(:,i)+a5*u_ddot(:,i));
% new displacement
u(:,i+1) = K_eff\F_eff;%inv(K_eff)*F_eff;
% new  acceleration and velocity
u_ddot(:,i+1) = a0*(u(:,i+1)-u(:,i))-a2*u_dot(:,i)-a3*u_ddot(:,i);
u_dot(:,i+1) = u_dot(:,i)+a6*u_ddot(:,i)+a7*u_ddot(:,i+1);
end

u=u';
end
