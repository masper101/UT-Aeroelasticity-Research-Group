%-------------------------------------------------------------------------
% code to read the pitch angle data file and process it
% first run pitchangle_collect_0.m --> creates the file pa.mat
%
% FUNCTIONS Called:
% fcleanup
% ffind_dft
%
% sirohi 191127
%-------------------------------------------------------------------------
clear all
close all

load('pa.mat');

fs = 1/(theta_data(1).tvec(2) - theta_data(1).tvec(1)); % sampling frequency, Hz

ndata = length(theta_data);

lenends = 2000;   % length of window to set to zero at each end of time series

% filter the signal and append it to the theta_data structure

for ii = 1:ndata
    
%     % smoothdata filter
%     theta_data(ii).filt_theta1 = fcleanup(theta_data(ii).theta1, 'smoothdata', 'lowess', lenends);
%     theta_data(ii).filt_theta2 = fcleanup(theta_data(ii).theta2, 'smoothdata', 'lowess', lenends);

%     % moving average filter
%     theta_data(ii).filt_theta1 = fcleanup(theta_data(ii).theta1, 'movmean', 500);
%     theta_data(ii).filt_theta2 = fcleanup(theta_data(ii).theta2, 'movmean', 500);
%     
    % lowpass followed by bandstop removing first three N/rev harmonics
    theta_data(ii).filt_theta1 = fcleanup(theta_data(ii).theta1, 0, 3, lenends, 500, fs, 15);
    theta_data(ii).filt_theta2 = fcleanup(theta_data(ii).theta2, 0, 3, lenends, 500, fs, 15);

    datalen(ii) = length(theta_data(ii).tvec);
    
end

% plot the Fourier Transform of each signal (windowed)

for ii = 1:ndata
    
    % find the fourier transform
    [fvec, magtheta1, ~, ~] = ffind_dft(theta_data(ii).tvec, theta_data(ii).theta1, lenends);
    [~, fmagtheta1, ~, ~] = ffind_dft(theta_data(ii).tvec, theta_data(ii).filt_theta1);

    % plot them
    figure(3);
    subplot(ndata,1,ii);
    semilogy(fvec, magtheta1, 'r-');
    hold on
    semilogy(fvec, fmagtheta1, 'k-');
    grid
    xlabel('Frequency, Hz');
    ylabel('Magnitude, deg');
    axis([0 500 0.0001 1]);

end

% cut all the data to the same length
datalen = min(datalen);

% cut time vector
ctvec = theta_data(1).tvec(lenends:datalen-lenends);

for ii = 1:ndata
    
    theta_data(ii).ctheta1 = theta_data(ii).theta1(lenends:datalen-lenends);
    theta_data(ii).ctheta2 = theta_data(ii).theta2(lenends:datalen-lenends);
    theta_data(ii).cfilt_theta1 = theta_data(ii).filt_theta1(lenends:datalen-lenends);
    theta_data(ii).cfilt_theta2 = theta_data(ii).filt_theta2(lenends:datalen-lenends);
    
    % plot everything
    figure(1);
    subplot(ndata,1,ii);
    plot(ctvec, theta_data(ii).ctheta1, 'r-');
    hold on
    plot(ctvec, theta_data(ii).cfilt_theta1, 'k-');
    grid
    xlabel('Time, s');
    ylabel('Theta1 mag, deg');
    
    figure(2);
    subplot(ndata,1,ii);
    plot(ctvec, theta_data(ii).ctheta2, 'b-');
    hold on
    plot(ctvec, theta_data(ii).cfilt_theta2, 'k-');
    grid
    xlabel('Time, s');
    ylabel('Theta2 mag, deg');

end

% calculate the cross-correlations of the signals based on a segment that
% includes only the rise (siglen)
%
% find the correct shifts
lowercutoff = 0.05;          % values below this are set as zero
uppercutoff = 0.90;          % values above this are set as =uppercutoff
siglen = 2000;               % length of signal to keep nonzero (in indices)
corrshift = zeros(ndata,1);  % vector of shifts (in indices)
%
for ii = 1:ndata
    
    % make the starting value zero
    t1(:,ii) = theta_data(ii).cfilt_theta1 - theta_data(ii).cfilt_theta1(1);
    
    % all values less than lowercutoff are set = 0
    t1(t1(:,ii)<lowercutoff,ii) = 0;
    
    % all values above uppercutoff are set = uppercutoff
    idx = find(t1(:,ii)>uppercutoff);
    t1(idx,ii) = uppercutoff;
    
    % find the first nonzero value and extract a signal of length siglen
    idx = find(t1(:,ii),1);
    t1(idx+siglen:end,ii) = 0;
    
    % find the cross-correlations and index shifts with reference to the
    % first signal
    if ii>1
        [acor, lags] = xcorr(t1(:,1), t1(:,ii), 2000);
%         figure(10)
%         plot(lags, acor);
%         pause
        [~,I] = max(abs(acor));
        corrshift(ii) = lags(I);
    end
    
end

% shift all the filtered signals by the corrshift
% cut them by the max(corrshift)
% append to theta_data --> processed theta
%
cends = lenends + max(corrshift);
cptvec = theta_data(1).tvec(cends:datalen-cends);
bad_runs = [];%[4 6 7 9];
pt1 = zeros(ndata-length(bad_runs),length(cptvec));
pt2 = zeros(ndata-length(bad_runs),length(cptvec));
frow = 1;
%
for ii = 1:ndata
    
    % shift the columns, cut them to the same size
    % put each data run in a row of a big matrix
    temp = circshift(theta_data(ii).filt_theta1, corrshift(ii));
    theta_data(ii).ptheta1 = temp(cends:datalen-cends);
    
    temp = circshift(theta_data(ii).filt_theta2, corrshift(ii));
    theta_data(ii).ptheta2 = temp(cends:datalen-cends);
    if ~ismember(ii, bad_runs)
        pt1(frow,:) = theta_data(ii).ptheta1;
        pt2(frow,:) = theta_data(ii).ptheta2;
        frow = frow+1;
    end
     
    % plot everything
    figure(4);
    plot(cptvec, theta_data(ii).ptheta1);
    pause
    hold on
    grid
    xlabel('Time, s');
    ylabel('Aligned Theta1, deg');
    
    figure(5);
    plot(cptvec, theta_data(ii).ptheta2);
    hold on
    grid
    xlabel('Time, s');
    ylabel('Aligned Theta2, deg');
    
end

% find the mean and standard deviation of all the filtered, aligned and cut
% pitch angles
%
mtheta1 = mean(pt1);
stheta1 = std(pt1);
mtheta2 = mean(pt2);
stheta2 = std(pt2);

figure(9)
plot(cptvec*15, mtheta1, 'k-', 'LineWidth', 2);
hold on
plot(cptvec*15, mtheta1-stheta1, 'r-', 'LineWidth', 1);
plot(cptvec*15, mtheta1+stheta1, 'r-', 'LineWidth', 1);
grid
xlabel('Time, s');
ylabel('Aligned Theta1, deg');

%save('pitch_angles.mat', 'theta_data', 'mtheta1', 'stheta1', 'mtheta2', 'stheta2', 'cptvec');
