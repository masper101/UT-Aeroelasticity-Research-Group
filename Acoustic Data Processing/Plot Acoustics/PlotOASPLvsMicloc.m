% PLOT OASPL VS MIC LOCATION
figure(4)
micloc=[-90:45/2:90];
cnt=0;
for i=[2:6,1]
    cnt=cnt+1;
    plot(micloc,[testdata{i}(1:9).oasplA],'o-')
    leg{cnt}=num2str(phi(i));
    hold on
end
xlabel('Mic Location, deg')
ylabel('OASPLA, dB')
l=legend(leg,'location','northeastoutside');
title(l,'Azimthual Spacing, deg:')
