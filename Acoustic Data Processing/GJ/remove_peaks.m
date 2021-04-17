function [ynopeak,ypeak] = remove_peaks(f0,df,n,y,p1,p2)
% filter at n multiples of index i0
% inputs:
% p1

ynopeak = y;

i0 = round(f0/df);
if f0/df ~= i0
    fprintf('f0/df = %f, round(f0/df) = %i i0',f0/df,i0)
end

for icen = i0:i0:n*i0 % for each peak region
    fp = round(icen*df); % peak frequency
    
    i1 = round(fp*p1/df); % width 1 in Hz, also index
    i2 = round(fp*p2/df); % width 2 in Hz, also index
    
    % extract non peak data
    ybb = y([icen-i2:icen-i1,icen+i1:icen+i2]);
    ybb = mean(ybb); % average of non peak data
    
    % replace peak with min of average value or total noise
    ynopeak(icen-i1:icen+i1) = min(y(icen-i1:icen+i1),ybb);
end

ypeak = y - ynopeak; % data with peaks only

% figure(10)
% loglog(y); hold on;
% loglog(ynopeak);
% loglog(ypeak);
end