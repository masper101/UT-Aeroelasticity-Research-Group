%TEST HARMONIC SIGNAL PROCESSING

%% Sampling
fs = 1000;     % Sampling rate [Hz]
Ts = 1/fs;     % Sampling period [s]
fNy = fs / 2;  % Nyquist frequency [Hz]
duration = 10; % Duration [s]
t = Ts : Ts : duration; % Time vector
noSamples = length(t);    % Number of samples
% Original signal
x = 220.*sin(2 .* pi .* 50 .* t);
% Harmonics
x1 = 100.*sin(2 .* pi .* 100 .* t);
x2 = 100.*sin(2 .* pi .* 200 .* t);
x3 = 100.*sin(2 .* pi .* 300 .* t);
% Contaminated signal
xn = x + x1 + x2 + x3;
% Add noise
% y = awgn(xn,1,'measured');    %white noise
noiselevel = 3000;
y = xn + noiselevel*rand(size(x));    %random noise
figure()
    plot(t,[xn; y])
    xlim([0,1/50*5])
    legend('No Noise',['Noise (SNR = ',num2str(220/noiselevel),')'])


%% Frequency analysis
% f = 0 : fs/noSamples : fs - fs/noSamples; % Frequency vector
% FFT
[f,fftx,~] = ffind_spectrum(fs,xn,length(xn),1);
[f,ffty,~] = ffind_spectrum(fs,y,length(y),1);
% Plot
figure()
    semilogy(f,fftx)
    hold on
    semilogy(f,ffty)
    legend('No Noise',['Noise (SNR = ',num2str(220/noiselevel),')'])
    xlabel('Frequency')


%% Averaging

% Dominant Frequency = 50 Hz 
f_dom = 50;
t_dom = 1/f_dom;
Nrevs = duration ./ t_dom; 
samplesperrev = t_dom*fs;
sortdata_x = zeros(Nrevs,samplesperrev); 
sortdata_y = zeros(Nrevs,samplesperrev); 
for revnum = 1:Nrevs
    sortdata_x(revnum,:) = xn((revnum-1)*samplesperrev+1:revnum*samplesperrev);
    sortdata_y(revnum,:) = y((revnum-1)*samplesperrev+1:revnum*samplesperrev);
end

x_avg = repmat(mean(sortdata_x),1,Nrevs);
y_avg = repmat(mean(sortdata_y),1,Nrevs);
x_noise = xn - x_avg;
y_noise = y - y_avg;

figure()
subplot(2,1,1)
    plot(t,x_avg)
    hold on
    plot(t,x_noise)
    xlim([0,5*t_dom])
    legend('Mean','Noise')
    title('No Noise')
subplot(2,1,2)
    plot(t,y_avg)
    hold on
    plot(t,y_noise)
    xlim([0,5*t_dom])
    legend('Mean','Noise')
    title(['Noise (SNR = ',num2str(220/noiselevel),')'])
    
%% Frequency Analysis

[f,fftx_avg,~] = ffind_spectrum(fs,x_avg,length(x_avg),1);
[f,fftx_noise,~] = ffind_spectrum(fs,x_noise,length(x_noise),1);

[f,ffty_avg,~] = ffind_spectrum(fs,y_avg,length(y_avg),1);
[f,ffty_noise,~] = ffind_spectrum(fs,y_noise,length(y_noise),1);

% Plot
figure()
subplot(2,1,1)
    plot(f,(fftx_avg))
    hold on
    plot(f,(fftx_noise))
    legend('Mean','Noise')
    title('No Noise')
    xlabel('Frequency')
subplot(2,1,2)
    plot(f,(ffty_noise))
    hold on
    plot(f,(ffty_avg),'k','linewidth',1.2)
    legend('Noise','Mean')
    title(['Noise (SNR = ',num2str(220/noiselevel),')'])
    xlabel('Frequency')
    ylim([0,250])

% figure()
%     plot(f,ffty_avg+ffty_noise,'.')
%     hold on
%     plot(f,ffty)
%     legend('Mean fft + Noise fft','fft(noise + mean)')
%     title('Noise (SNR = 1): fft of the noise + fft of the mean = fft of (noise + mean)')
%     xlabel('Frequency')
