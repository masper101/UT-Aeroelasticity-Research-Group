% Time Averaging
clear revdata
Ntest = length(testdata);

%% DIVIDE INTO REVS
for i = 1:Ntest
    for micnum = 11
        f = testdata{i}(micnum).fvec;
        P = testdata{i}(micnum).Pdata;
        t = testdata{i}(micnum).tvec;
        P_t = testdata{i}(micnum).Pdata_t;
        fs = testdata{i}(micnum).fs;
        N = length(P_t);
        
        % get 1/rev
%         stream = 11;
%         SR = 10000;
%         binsize_loads = SortedData.binsize{stream};
%         binsize = binsize_loads*fs/SR;
                [m,loc] = max(P);
                bpf = f(loc);
                rpm = bpf*60;
                while rpm>1500
                    rpm = rpm./2;
                end
                rps = rpm./60;
                spr = round(fs/rps);   % samples per rev
                Nrevs = round(N./spr); % number of revs recorded
        
        % sort into revs
        revdata{i}(micnum).P = [];
        revdata{i}(micnum).t = [];
        count = 1;
        check = 1;
%         for n = 1:length(binsize)
%             b = round(binsize(n));
%             revdata{i}(micnum).P(n,1:b) = P_t(count:count - 1+ b)';
%             revdata{i}(micnum).t(n,1:b) = t(1:b)';
%             count = count + b;
%         end
%         while count<=length(P_t)
%             n = n+1;
%             b = round(mean(binsize));
%             if count - 1 + b > length(P_t)
%                 excess = length(P_t) - count + 1;
%                 revdata{i}(micnum).P(n,1:excess) = P_t(count:end)';
%                 revdata{i}(micnum).t(n,1:excess) = t(1:excess)';
%             else
%                 revdata{i}(micnum).P(n,1:b) = P_t(count:count - 1+ b)';
%                 revdata{i}(micnum).t(n,1:b) = t(1:b)';
%             end   
%             count = count + b;
%         end        
%         loc_zeros = [revdata{i}(micnum).P==0];
%         revdata{i}(micnum).P(loc_zeros) = nan; 
%         revdata{i}(micnum).t(loc_zeros) = nan; 

            for n = 1:Nrevs
                    if n == Nrevs
                        excess = length(P_t(count:end));
                        revdata{i}(micnum).P(n,1:excess) = P_t(count:end)';
                        revdata{i}(micnum).t(n,1:spr) = t(1:spr)';
                    else
                        revdata{i}(micnum).P(n,1:spr) = P_t(count:count-1+spr)';
                        revdata{i}(micnum).t(n,1:spr) = t(1:spr)';
                        count = count +  spr;
                    end
            end
        
    end
end

tavg = mean(revdata{i}(micnum).t);
Pavg = mean(revdata{i}(micnum).P);
Perr = std(revdata{i}(micnum).P);
figure()
plot_confidenceint(tavg,Pavg,Perr, 'r')
title('Averaged data with 1 standard deviation')

figure()
plot(revdata{i}(micnum).t,revdata{i}(micnum).P)
hold on
plot_confidenceint(tavg,Pavg,Perr, 'r')
title('All revolutions + averaged')
%% AUTOCORRELATE
% P_rev = revdata{i}(micnum).P;
% [c,lags] = xcorr(P_rev,fs*5,'unbiased');
% figure()
% plot(lags,c)
% title('Autocorrelation of raw data')
%% CROSSCORRELATE EACH REV
figure()
plot(t,P_t)
title('Total time signal')
for i = 1:Nrevs
    [c,lags] = xcorr(P_rev(1,:), P_rev(i,:),'normalized');
    corr(i) = max(c);
      
        plot(lags,c)
        pause

    
end

%% LOWPASS FILTER
lpf = bpf * 2;
P_filt = lowpass(P_t,lpf,fs);
figure()
plot(t,P_t)
hold on
plot(t,P_filt,'k','linewidth',1.2)
% xlim([0,spr])
legend('Raw','Lowpass Filter')
title('Data with filter, no averaging, 1 revolution')