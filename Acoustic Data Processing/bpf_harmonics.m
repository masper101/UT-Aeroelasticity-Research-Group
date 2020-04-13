clear; clc; close all
% a = [5 5 5 5 5 zeros(1,100)];
t = .01:.01:1;
abase = [1*ones(length(t)/2), -1*ones(length(t)/2)];

[f, afft] = ffind_dft(t',abase');
figure(5)
subplot(4,1,1)
plot(f,afft)

a = [abase abase];
t = .01:.01:2;
[f, afft] = ffind_dft(t',a');
subplot(4,1,2)
plot(f,afft)

a = [abase abase abase abase abase abase abase abase abase abase];
t = .01:.01:10;
[f, afft] = ffind_dft(t',a');
subplot(4,1,3)
plot(f,afft)

a = [abase abase abase abase abase abase abase abase abase abase abase abase abase abase abase abase abase abase abase abase];
t = .01:.01:20;
[f, afft] = ffind_dft(t',a');
subplot(4,1,4)
plot(f,afft)
hold on
plot(f,4/pi./f) %fourier series of a square wave is proportional to 4/pi/n * odd sine functions
ylim([0,5])