function [fvec, magVs, psdVs, dftVsc] = ffind_dft(tvec, Vs, winlen)
% function to return dft and frequency vector of a time signal
% Vs must be uniformly sampled, i.e., dt = constant
% inputs :
% tvec - time vector
% Vs - signal
% winlen - number of elements to "window" out
% outputs :
% fvec - frequency vector
% magVs - magnitude of signal
% psdVs - power spectral density of signal
% dftVsc - discrete fourier transform of signal
%
% sirohi 191129
%

fs = 1/(tvec(2)-tvec(1));

if nargin==3
    if winlen > 0
        % define a windowing function to make the ends of the signal = 0
        trad = linspace(0,1,winlen)*pi;
        winfn = [0.5-cos(trad)*0.5 ones(1,length(Vs)-2*winlen) cos(trad)*0.5+0.5]';
    else
        % default (winlen=0) is the blackman window
        winfn = blackman(length(Vs));
    end
    wVs = Vs .*winfn;
else
    wVs = Vs;
end

% pad the end of the vectors if length of the vector is odd
if ( mod(length(tvec),2) == 1 )
    dt = tvec(2) - tvec(1);
    tvec = [tvec ; tvec(end)+dt];
    wVs = [wVs ; wVs(end)];
end

dftVsc = fft(wVs);                                 % calculate FFT
dftVs = dftVsc(1:length(tvec)/2+1);                % throw away negative frequencies
magVs = 1/length(tvec)*abs(dftVs)*2;               % only magnitude at each frequency
psdVs = (1/(fs*length(tvec))) * abs(dftVs).^2;     % calculate power and scale it
psdVs(2:end-1) = 2*psdVs(2:end-1);                 % multiply by two to account for negative frequencies
fvec = 0:fs/length(tvec):fs/2;                     % generate properly scaled frequency vector

end