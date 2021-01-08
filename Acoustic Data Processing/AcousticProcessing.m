% PROCESS MISC ACOUSTIC DATA 
% CMJOHNSON 06/08/2020
% PROCESS SINGLE TEST ACOUSTIC DATA FILES USING CALIBRATION DATA FILES AND DATA FILES
 
% INPUTS
%     testdate                -> calibration test date / data test date
%     testletter              -> calibration test letter / data test letter
%     calsuffix               -> [] or anything added to end of "cal"
%     plots = true or false   -> plots calibration files
%     filename                -> name of calibration xlsx sheet
%     dirname                 -> location of calibration xlsx sheet
% 
% OUTPUTS
%     caldata
%         .scale              -> max magnitude of wav file at desired calibration frequency
%         .calmag
%         .tvec
%         .wavdata
%         .fs
%         .fvec
%     testdata
%         .fvec
%         .fs
%         .wavdata
%         .tvec
%         .testmag
%         .Pdata [Pa]
%         .Pdata_t [Pa]       -> Pressure in time domain
%         .dbdata
%         .ofilt12_dbdata
%         .ofilt3_dbdata
%         .oaspl

clear; clc; close all
warning off

%% INPUTS
directory = '/Users/chloe/Box/Chloe Lab Stuff/2020 Fall Stacked Rotor/Acoustic Tests';

%% PROCESSING
[testnames, testdata, caldata] = fAcProc(directory);

fprintf('\n\n%s\n\n', 'Processing done.');

%% PLOT
% k=1;
% RPM=990;
% micnum = 3;
% figure(1)
% semilogx(testdata{k}(micnum).fvec, testdata{k}(micnum).dbdata)
% xlim([10^1 10^4]);
% ylim([0 80])
% hold on
% fplotperrev(RPM)
% xlabel('Frequency, Hz')
% ylabel('dB')
phi = [90,28.125,39.375,45,50.625,67.5];
micnum = 5;
RPM=1200;
load('colors.mat')
lsty='-';

leg={};
lines=[];
cnt=0;
f1=figure(2);
Ax(1) = axes(f1); 
for i=[2:6,1]
    cnt=cnt+1;
    lines(end+1)=semilogx(testdata{i}(micnum).ofilt12_fvec, testdata{i}(micnum).ofilt12_dbdata+(cnt-1)*40,'color',colors{cnt},'linestyle',lsty,'linewidth',1.2);
hold on
leg{cnt}=[num2str(phi(i)) ' + ' num2str(40*(cnt-1)) 'dB'];
end
leg{1}=num2str(phi(2));
% lines(end+1)=semilogx(testdata{1}(micnum).ofilt12_fvec, testdata{1}(micnum).ofilt12_dbdata,'color',colors{1},'linestyle',lsty,'linewidth',1.2);
xlim([10^1 10^4]);
% ylim([0 300])
fplotperrev(RPM)
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
%%
figure(3)
micloc=[0,360-45/2:-45/2:180]./180*pi;
for i=[1:3]
polarplot(micloc,[testdata{i}(1:9).oaspl],'o-')
hold on
end

ax=gca;
ax.ThetaZeroLocation ='top';
ax.ThetaTick = [0:45:360-45];
ax.ThetaTickLabel = {0,360-45:-45:45};
rlim([0,100])
l=legend('-2','0','2');
title(l,'Collective, deg:')
title('11/18/20: 4-bladed, 1200 RPM')

%%
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
%%

figure(5)
k=2+5;
lsty='-';
leg={};
% line=[];
for i = 1:11
line(end+1)=semilogx(testdata{k}(i).ofilt12_fvec, testdata{k}(i).ofilt12_dbdata+40*(i-1),'linestyle',lsty,'linewidth',1.2);
hold on
leg{2*i-1}=[num2str(i) ' + ' num2str(40*(i-1)) 'dB'];
leg{2*i}='';
end
xlim([10^1 10^4]);
fplotperrev(RPM)
xlabel('Frequency, Hz')
ylabel('dB')
l2=legend(line(1,[1,12]),'11/17/20','11/18/20')
title(l2,'Date:')
leg{1}=num2str(1);
% l=legend(leg);
% title(l,'Mic:')


%%
% d=dir('*.fig'); % capture everything in the directory with FIG extension
% allNames={d.name}; % extract names of all FIG-files
% close all; % close any open figures
% for i=1:length(allNames)
%       open(allNames{i}); % open the FIG-file
%       base=strtok(allNames{i},'.'); % chop off the extension (".fig")
%       print('-djpeg',base); % export to JPEG as usual
%       close(gcf); % close it ("gcf" returns the handle to the current figure)
% end