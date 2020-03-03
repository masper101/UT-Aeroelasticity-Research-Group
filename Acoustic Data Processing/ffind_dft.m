function [fvec, magVs, psdVs, dftVsc] = ffind_dft(tvec, Vs, winlen)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to return dft and frequency vector of a time signal
% Vs must be uniformly sampled, i.e., dt = constant
%
%   Inputs:
%       tvec - time vector
%       Vs - signal
%       winlen - number of elements to "window" out
%
%   Outputs:
%       fvec - frequency vector
%       magVs - magnitude of signal
%       psdVs - power spectral density of signal
%       dftVs - discrete fourier transform of signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs = 1/(tvec(2)-tvec(1));

if nargin == 3
    
    % Define a windowing function to make the ends of the signal = 0
    trad = linspace(0,1,winlen)*pi;
    winfn = [0.5-cos(trad)*0.5 ones(1,length(Vs)-2*winlen) cos(trad)*0.5+0.5]';
    wVs = Vs .*winfn;
    
else
    
    wVs = Vs;
    
end

% Pad the end of the vectors if length of the vector is odd
if ( mod(length(tvec),2) == 1 )
    
    dt = tvec(2) - tvec(1);
    tvec = [tvec ; tvec(end)+dt];
    wVs = [wVs ; wVs(end)];
    
end

dftVsc = fft(wVs);                                                         % Calculate FFT
dftVs = dftVsc(1:length(tvec)/2+1);                                        % Throw away negative frequencies
magVs = 1/length(tvec)*abs(dftVs)*2;                                       % Only magnitude at each frequency
psdVs = (1/(fs*length(tvec))) * abs(dftVs).^2;                             % Calculate power and scale it
psdVs(2:end-1) = 2*psdVs(2:end-1);                                         % Multiply by two to account for negative frequencies
fvec = 0:fs/length(tvec):fs/2;                                             % Generate properly scaled frequency vector

end