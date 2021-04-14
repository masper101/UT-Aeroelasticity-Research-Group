function [P_sort, P_tonal, P_bb] = fPhaseAvg(P_t, enc)

%sort data
[pks,locs] = findpeaks(enc, 'MinPeakHeight', 1e-3);
Nrevs = length(pks) - 1;

P_sort = zeros(Nrevs, 4000);
xq = 360/4000 : 360/4000 : 360;
for revnum = 1:Nrevs
    binsize = locs(revnum+1) - locs(revnum);
    x = 360/binsize : 360/binsize : 360; 
    P_sort(revnum,:) = interp1(x, P_t(locs(revnum):locs(revnum+1)-1), xq,'pchip'); 
end

%seperate into tonal and broadband data
P_tonal = repmat(nanmean(P_sort),1,Nrevs); 
P_bb = reshape(P_sort',1,Nrevs*4000) - P_tonal; 
%mean RPM -> time per rev -> dt per azimuth 