% PLOT MULTIPLE SPECTRA WITH LEGEND 
phi = [90,28.125,39.375,45,50.625,67.5];
micnum = 5;
RPM=990;
bladenumber=2;
load('colors.mat')
lsty='-';

leg={};
lines=[];
cnt=0;
f1=figure(2);
Ax(1) = axes(f1); 
for i=[1]
    cnt=cnt+1;
    lines(end+1)=semilogx(testdata{i}(micnum).ofilt12_fvec, testdata{i}(micnum).ofilt12_dbdata+(cnt-1)*40,'color',colors{cnt},'linestyle',lsty,'linewidth',1.2);
hold on
leg{cnt}=[num2str(phi(i)) ' + ' num2str(40*(cnt-1)) 'dB'];
end
leg{1}=num2str(phi(2));
% lines(end+1)=semilogx(testdata{1}(micnum).ofilt12_fvec, testdata{1}(micnum).ofilt12_dbdata,'color',colors{1},'linestyle',lsty,'linewidth',1.2);
xlim([10^1 10^4]);
% ylim([0 300])
fplotperrev(RPM,bladenumber)
title(['Mic ',num2str(micnum)]);
xlabel('Frequency, Hz')
ylabel('dB')
l=legend(leg,'location','northeastoutside');
title(l,'Azimthual Spacing, deg:')

% set(Ax(1), 'Box','off')
% 
% 
% Ax(2) = copyobj(Ax(1),gcf);
% delete( get(Ax(2), 'Children') )

% lsty='--';
% cnt=0;
% for i=6:10
%     cnt=cnt+1;
%     lines(end+1)=semilogx(testdata{i}(micnum).ofilt12_fvec, testdata{i}(micnum).ofilt12_dbdata+(cnt-1)*40,'color',colors{cnt},'linestyle',lsty,'linewidth',1.2);
% end
% set(Ax(2), 'Color', 'none', 'XTick', [], 'YAxisLocation', 'right', 'Box', 'Off', 'Visible', 'off') %make it transparent
% 
% l=legend(Ax(1),lines(1:4),'0','8 + 40dB','10 + 80dB','12 + 120dB','location','northeastoutside');
% title(l,'Collective, deg:')
% l2=legend(Ax(2),lines(1,[6,7]),'11/17/20','11/18/20','location','southeastoutside');
% title(l2,'Date:')
% set(l2,'color','w')

