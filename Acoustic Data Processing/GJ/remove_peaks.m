function [ynopeak,ypeak] = remove_peaks(f0,df,n,y,inner,outer)
% filter at n multiples of index i0
% inputs:
% f0, first frequency
% df, freq step size
% n - number of peaks to filter
% y total signal
% inner - inner range (index units)
% outer - outer range (index units)

ynopeak = y;

i0 = round(f0/df);
if f0/df ~= i0
    fprintf('f0/df = %f, round(f0/df) = %i i0',f0/df,i0)
end

for icen = i0:i0:n*i0 % for each peak region
    fp = round(icen*df); % peak frequency
    
    % use percentage
    %i1 = ceil(fp*p1/df); % width 1 in Hz, also index
    %i2 = ceil(fp*p2/df); % width 2 in Hz, also index
       
    % extract non peak data
    ybb = y([icen-outer:icen-inner,icen+inner:icen+outer]);
    ybb = mean(ybb); % average of non peak data
    
    % replace peak with min of average value or total noise
    ynopeak(icen-inner:icen+inner) = min(y(icen-inner:icen+inner),ybb);
end

ypeak = y - ynopeak; % data with peaks only

%figure(10)
%loglog(y); hold on;
%loglog(ynopeak);
%loglog(ypeak);
end