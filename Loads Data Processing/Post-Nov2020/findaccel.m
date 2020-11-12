RPM = 1200; 
k = 6;

prev = 1200/60; 

dt = 1/10000;
tvec = dt:dt:length(StreamData.ax{k})*dt;
[fvec, magVsx, psdVs, dftVs2] = ffind_dft(tvec, StreamData.ax{k});
loc = (fvec>prev*0.8) & (fvec<prev*1.2); 
ax = max(magVsx(loc)); 

[fvec, magVsy, psdVs, dftVs2] = ffind_dft(tvec, StreamData.ay{k});
ay = max(magVsy(loc)); 

figure(1)
plot(fvec, magVsx)
hold on
plot(fvec, magVsy)
ylim([0,0.5])
xlim([0,100])
legend('a_x','a_y')
ylabel('Accel [g]')
hold off

a = sqrt(ax.^2 + ay.^2)


bandpass(RevData.avg_ax{k},[prev*0.8,prev*1.2],10000)