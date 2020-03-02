function RevData = CheckCorrelation(RevData)

for k = 1:length(RevData.Fx_outer)
    avg1 = nanmean(mean(RevData.Mz_outer{k}));
    avg2 = nanmean(mean(RevData.Mz_inner{k}));
    avg3 = nanmean(mean(RevData.FM_outer{k}));
    avg4 = nanmean(mean(RevData.FM_inner{k}));
    
    R1 = [nanstd(RevData.Mz_outer{k},[],2) / avg1] > .6;
    R2 = [nanstd(RevData.Mz_inner{k},[],2) / avg2] > .6;
    R3 = [nanstd(RevData.FM_outer{k},[],2) / avg3] > 20;
    R4 = [nanstd(RevData.FM_inner{k},[],2) / avg4] > 20;
    R = or(or(R1,R2),or(R3,R4));
%     sum(R)
%     close all
%     for i = 1:1:101
%         plot(RevData.Mz_outer{k}(i,:))
%         hold on
%         plot(RevData.Mz_inner{k}(i,:))
%     end
    plot(RevData.Mz_outer{k}(R,:),'o')
    plot(RevData.Mz_inner{k}(R,:),'o')
    RevData.Fx_outer{k}(R,:) = [];
    RevData.Fy_outer{k}(R,:) = [];
    RevData.Fz_outer{k}(R,:) = [];
    RevData.Mx_outer{k}(R,:) = [];
    RevData.My_outer{k}(R,:) = [];
    RevData.Mz_outer{k}(R,:) = [];
    RevData.Fx_inner{k}(R,:) = [];
    RevData.Fy_inner{k}(R,:) = [];
    RevData.Fz_inner{k}(R,:) = [];
    RevData.Mx_inner{k}(R,:) = [];
    RevData.My_inner{k}(R,:) = [];
    RevData.Mz_inner{k}(R,:) = [];
    
    RevData.cts_outer{k}(R,:) = [];
    RevData.cps_outer{k}(R,:) = [];
    RevData.cts_inner{k}(R,:) = [];
    RevData.cps_inner{k}(R,:) = [];
    
    RevData.FM_outer{k}(R,:) = [];
    RevData.FM_inner{k}(R,:) = [];
    RevData.FM_tot{k}(R,:) = [];
end