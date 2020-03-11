function [fvec, magVs, psdVs, dftVsc] = ffind_dft(tvec, Vs, winlen)
function [fvec, magVs, psdVs, dftVs2] = ffind_dft(tvec, Vs, winlen)
%--------------------------------------------------------------------------
% function to return dft and frequency vector of a time signal
% Vs must be uniformly sampled, i.e., dt = constant
% 
% INPUTS :
% tvec - time row vector
% Vs - signal row vector
% winlen - number of elements to "window" out
%
% OUTPUTS :
% fvec - frequency vector
% magVs - magnitude of signal
% psdVs - power spectral density of signal
% dftVs2 - 2-sided DFT of signal
%
% sirohi 191129
%        200309 v2: fixed length of output vectors, psd scaling
%                   
%--------------------------------------------------------------------------

% pad the end of the vectors if length of the vector is odd
if ( mod(length(tvec),2) == 1 )
    dt = tvec(2) - tvec(1);
    tvec = [tvec tvec(end)+dt];
    wVs = [wVs wVs(end)];
end

fs = 1/(tvec(2)-tvec(1));
N = length(tvec);
n = 0:1:N-1;          % time indices
k = 0:1:N-1;          % frequency indices
f = k *fs/N;          % frequency vector

if nargin==3
    if winlen > 0
        % define a windowing function to make the ends of the signal = 0
        trad = linspace(0,1,winlen)*pi;
        winfn = [0.5-cos(trad)*0.5 ones(1,length(Vs)-2*winlen) cos(trad)*0.5+0.5];
    else
        % default (winlen=0) is the rectangular window
        winfn = rectwin(N);
        winfn = winfn .*sqrt(N/sum(winfn.^2));   % normalize window for P = 1;
    end
    wVs = Vs .*winfn;
else
    wVs = Vs;
end

dftVs2 = fft(wVs);                       % calculate 2-sided FFT
magVs2 = 1/N *abs(dftVs2);               % magnitude at each frequency
psdVs2 = abs(dftVs2).^2/ N^2;            % power in each bin

magVs = 2 *magVs2(1:N/2);                % multiply by two to account for negative frequencies
psdVs = 2 *psdVs2(1:N/2);                % multiply by two to account for negative frequencies
fvec = f(1:N/2);                         % generate properly scaled frequency vector

end