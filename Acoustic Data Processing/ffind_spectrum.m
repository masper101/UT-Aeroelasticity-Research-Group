function [fvec, magX, powerX] = ffind_spectrum(fs, x, NFFT, Nav, win)
%--------------------------------------------------------------------------
% function to return spectrum of a time signal
% Vs must be uniformly sampled, i.e., dt = constant
% divides the input signal into blocks and averages the spectra
% 
% INPUTS :
% fs   - sampling frequency, Hz
% x    - signal row vector
% NFFT - number of elements to use for FFT (must be even)
% Nav  - number of averages (must be odd)
% win  - window type - omit if no window required
%
% OUTPUTS :
% fvec - frequency vector
% magX - magnitude of signal
% powerX - power/bin of the signal
%
% sirohi 200310 modified from ffind_dft
%               same as:
%               [Pxx,F] = pwelch(x,rectwin(NFFT),0,NFFT,fs, 'power');
%                   
%--------------------------------------------------------------------------

% pad the end of the vectors if length of the vector is odd
if ( mod(length(x),2) == 1 )
    x = [x x(end)];
end

N = length(x);
n = 0:N-1;          % time indices
tvec =  n/fs;       % time vector
k = 0:NFFT-1;       % frequency indices
f = k *fs/NFFT;     % frequency vector

if nargin==5
    eval(['winfn = ' win '(NFFT);']);
    winfn = winfn .*sqrt(NFFT/sum(winfn.^2)); % normalize window for P= 1 W
else
    winfn = rectwin(NFFT);
end

% create matrix with NFFT rows and Nav columns, each containing a block of x  
xblock = zeros(NFFT, Nav);
if Nav>1
    Noffset = floor((N-NFFT) /(Nav-1));
else
    Noffset = 0;
end

if Noffset==0
    Nav = 1;
end

Noverlap = (1 -Noffset/NFFT)*100;
disp(['Block size: ' num2str(NFFT) ' Averages: ' num2str(Nav) ' Overlap: '...
    num2str(Noverlap) '%']);
    
for iav = 1:Nav
    idx1 = (iav-1) *Noffset +1;
    idx2 = idx1 +NFFT -1;
    xblock(:,iav) = x(idx1:idx2);
    xblock(:,iav) = xblock(:,iav).*winfn;
end

% find the DFTs, scale, average
DFTXblock2 = fft(xblock);              % matrix containing the DFT of the columns of xblock
DFTXblock = DFTXblock2(1:NFFT/2, :);   % single-sided DFT
magXblock = abs(DFTXblock);             % absolute value

magVs2 = 2 /NFFT *magXblock;           % magnitude at each frequency
powerVs2 = 2* magXblock.^2/ NFFT^2;      % power in each bin

magX = mean(magVs2,2);                % average of all the blocks
powerX = mean(powerVs2,2);

fvec = f(1:NFFT/2);                    % generate frequency vector

end