function [varargout] = svd_csm(x,fs)
%Computes the singular value decomposition plot of the cross-power spectral density matrix
% This is used to determine the existence of closely spaced modes in vibration tests. A set
% of N measurement channels (e.g. accelerometers) is used to create a single figure containing 
% all relevant information, by performing singular value decomposition of the matrix of cross-power
% densities.
%
% Author: Marc Eitner
% Created: Jan 2020
%
% Input: 
%           x:    measurements [N x dof]
%          fs:    scalar [Hz]
% Output: 
%           []:   plot of singular value spectra
%         [sv]:   returns matrix sv containing singular value spectra
%       [sv,f]:   returns matrix sv as well as a frequency vector




% compute the power spectral density matrix. The diagonal entries are the
% auto-power spectra and the off-diagonal entries are the cross-power
% spectra of the measurements
for i=1:size(x,2)
    for j=1:size(x,2)
        [csm(i,j,:),f]=cpsd(x(:,i),x(:,j),[],[],[],fs);
    end
end

% perform svd of the csm matrix at each frequency bin
for i = 1:size(csm,3)
    [~,S,~] = svd(csm(:,:,i));
    sv(:,i) = diag(S);
end

% plot singular values in dB
if nargout == 0
    plot(f,mag2db(sv),'LineWidth',2)
    xlabel('Frequency [Hz]')
    ylabel('Singular values [dB]')
elseif nargout == 1
    varargout{1} = sv;
elseif nargout == 2
    varargout{1} = sv;
    varargout{2} = f;
end
end
