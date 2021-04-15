function [P_sort, P_tonal, P_bb, fs_new] = fPhaseAvg(P_t, enc)

%sort data
[pks,locs] = findpeaks(enc, 'MinPeakHeight', 1e-3);
Nrevs = length(pks) - 1;

P_sort = zeros(Nrevs, 4000);
binsize = zeros(Nrevs,1);

xq = 360/4000 : 360/4000 : 360;
for revnum = 1:Nrevs
    binsize(revnum) = locs(revnum+1) - locs(revnum);
    x = 360/binsize(revnum) : 360/binsize(revnum) : 360; 
    P_sort(revnum,:) = interp1(x, P_t(locs(revnum):locs(revnum+1)-1), xq,'pchip'); 
end

%seperate into tonal and broadband data
P_tonal = repmat(nanmean(P_sort),1,Nrevs); 
P_bb = reshape(P_sort',1,Nrevs*4000) - P_tonal; 

%calc new sampling freq from average omega
fs = 48000;
omega = fs./ mean(binsize);
sec_per_rev = 1/omega;
dt = sec_per_rev / 4000; 
fs_new = 1/dt;

