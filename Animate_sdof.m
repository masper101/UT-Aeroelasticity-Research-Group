%% Animate sdof system
% This script animates the vibration of a single degree of freedom
% oscillator. Three different oscillations can be animated, a
% step response, impulse response and ramp response. Alternatively a
% displacement and force vector can be imported. The script creates a video
% file in the current directory.
%
% Author:  Marc Eitner
% Created: Aug 2018


% define constants
omega = 1; % undamped natural frequency [rad/s]
t = linspace(0,100,1000); % time vector
zeta = 0.022; % damping ratio
N = length(t);


% define dimensions of box
w = 2; %(half width)
h = 1; %(height)


%%%%%%%%%%%%%%%%%%%%% pick a force and response %%%%%%%%%%%%%%%%%%%%%%%%%%%
% impuls response
%tau = 10;
%x = 1/1/omega*exp(-0.022*omega*(t-tau)).*(t>tau).*sin(omega*(t-tau));
%F = 1*(t>tau).*(t<tau+1);

% ramp response
x = 1/20*(t-2*zeta/omega+exp(-zeta*t*omega).*(2*zeta/omega*cos(omega*t)...
+(2*zeta^2-1)/omega*sin(omega*t)));
F = linspace(0,1,N);

% step response
% tau = 5;
% F = 1*(t>tau);
% x = 1/1*(1-exp(-zeta*omega*(t-tau)).*(cos(omega*(t-tau))+zeta*sin(omega*(t-tau)))).*(t>tau);


% display figure in fullscreen to improve video quality
fig = figure;
fig.WindowState = 'fullscreen';

% loop over each time-step and create image
for i = 1:N
    delete(subplot(1,2,1));
    subplot(1,2,1)
    axis([-3*w 3*w -2 6]);
    axis off
    
P1 = [0 2+x(i)];

line([-w w],[P1(2)+h/2 P1(2)+h/2],'LineWidth',2);
line([-w w],[P1(2)-h/2 P1(2)-h/2],'LineWidth',2);
line([-w -w],[P1(2)+h/2 P1(2)-h/2],'LineWidth',2);
line([w w],[P1(2)-h/2 P1(2)+h/2],'LineWidth',2);

% define intermediate points for spring 1
    S11 = [0 6-abs(6-P1(2)-h/2)*0.10     ];
    S12 = [0.2 6-abs(6-P1(2)-h/2)*0.2   ];
    S13 = [-0.2 6-abs(6-P1(2)-h/2)*0.35   ];
    S14 = [0.2 6-abs(6-P1(2)-h/2)*0.50   ];
    S15 = [-0.2 6-abs(6-P1(2)-h/2)*0.65   ];
    S16 = [0.2 6-abs(6-P1(2)-h/2)*0.80   ];
    S17 = [0 6-abs(6-P1(2)-h/2)*0.90  ];
% define detailed spring 1
     line([0 S11(1)],[6 S11(2)]);
     line([S11(1) S12(1)],[ S11(2) S12(2)]);
     line([S13(1) S12(1)],[ S13(2) S12(2)]);
     line([S13(1) S14(1)],[ S13(2) S14(2)]);
     line([S15(1) S14(1)],[ S15(2) S14(2)]);
     line([S15(1) S16(1)],[ S15(2) S16(2)]);
     line([S17(1) S16(1)],[ S17(2) S16(2)]);
     line([S17(1) P1(1)],[ S17(2) P1(2)+h/2]);

% line for ceiling
line([-2*w 2*w],[6 6]);

% show coordinate system
line([-4 -4],[2 2.5]);
line([-3.9 -4],[2.4 2.5]);
line([-4.1 -4],[2.4 2.5]);
line([-3.9 -4.1],[2 2]);
text(-4.6, 2.5,'x');

% add a text box for explanation
text(-3, -2,'Step Response');

subplot(1,2,2)
yyaxis left
plot(t(1:i),x(1:i))
axis([0 100 -2 2]);
xlabel('Time [s]')
ylabel('Displacement [m]')

yyaxis right
plot(t(1:i),F(1:i),'--')
ylabel('Force [N]')
axis([0 100 -1.2 1.2])
legend('x','Force')
pause(0.01)

 M(i) = getframe(1);
 end
video = VideoWriter('sdof_response.avi');
open(video)
writeVideo(video,M)
close(video)
