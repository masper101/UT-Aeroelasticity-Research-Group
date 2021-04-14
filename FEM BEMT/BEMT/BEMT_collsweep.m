ths = [0:1:12];
CTs = zeros(size(ths));
for i = 1:length(ths)
    th_0 = ths(i)
[r,dr,dCT,CT,sig,CP,FM] = f_BEMT(R,c,cutout,th_0,th_tw,Nb,N,plots,OMEGA,AF);
CTs(i) = CT;
end
hold on
plot(ths, CTs/sig,'o-')