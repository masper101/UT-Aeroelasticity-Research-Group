RPM = 550; 
k = 6;

prev = RPM/60; 

dt = 1/10000;
tvec = dt:dt:length(StreamData.ax{k})*dt;
[fvec, magVsx, psdVs, dftVs2] = ffind_dft(tvec, StreamData.ax{k});
loc = (fvec>prev*0.8) & (fvec<prev*1.2); 
ax = max(magVsx(loc)); 

[fvec, magVsy, psdVs, dftVs2] = ffind_dft(tvec, StreamData.ay{k});
ay = max(magVsy(loc)); 

figure(1)
subplot(2,1,1)
plot(fvec, magVsx)
hold on
ylabel('a_x')
ylim([0,0.1])
xlim([0,100])

subplot(2,1,2)
hold on
plot(fvec, magVsy)
ylim([0,0.1])
xlim([0,100])
ylabel('a_y')
ylabel('Accel [g]')


a = sqrt(ax.^2 + ay.^2)

figure(2)
hold on
plot(fvec, magVsy)
ylim([0,0.1])
xlim([0,100])
ylabel('a')
ylabel('Accel [g]')

% bandpass(RevData.avg_ax{k},[prev*0.8,prev*1.2],10000)