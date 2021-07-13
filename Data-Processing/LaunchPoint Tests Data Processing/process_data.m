clc; clear; close all;
load('colors.mat');

%{
This script post-processes current sensor data from Stacked Rotor tests. 
Streaming files are read and processed
I1: UB-; I2: UB+
sData: I1 (UB-): col-16, I2 (UB+): col-17 

Errors
I_bias = 0.75 A (75 A F.S. ~ 1% error)
I_precision = std(I)/sqrt(N)*1.96
I_tot = sqrt(I_p^2 + I_b^2)

 %}

%Constants
rho     = 1.225;                                                            % [kg/m^3]
R       = 1.108;                                                            % [m]
A       = pi*R^2;                                                           % area [m^2]
c       = 0.08;                                                             % chord [m]
I_b     = 0.75;                                                             % CR5410-75S bias error [A]
T_b     = 8;                                                                % Omega160 Fz bias error [N]
Q_b     = 0.5;                                                              % Omega160 Tz bias error [N-m]
V_bus   = 175;                                                              % Bus voltage [V]

filename = input('Test file names (YYMMDD_test_x): ','s');
RPM      = input('RPM: ','s');
Nb       = str2double(input('Number of blades: ','s'));
sigma    = R*c*Nb / (pi*R^2);

%% Load analytical comparison
fprintf('Select Analytical Prediction File to Load...\n');
[analytical_file,analytical_path] = uigetfile(strcat('/Users/asper101/Box Sync/',...
    'Matt Lab Stuff/Electromechanical Modelling/Analytical Modelling'));
analytical_data = load(fullfile(analytical_path,analytical_file));

cnt = 0;

%get averages and filepath
fprintf('Select Experimental Data Directory...\n');
Exp_data_dir = uigetdir('/Users/asper101/Box Sync/');
mean_filename = strcat(filename,' mean','.csv');
if isfile(fullfile(Exp_data_dir,mean_filename))
    fprintf(strcat(mean_filename,'...\n'));
    fileID = fopen(fullfile(Exp_data_dir,mean_filename),'r');
    means = textscan(fileID,'%f %f %f %f %f %f %f %s','Delimiter',',','HeaderLines',1);
    fclose(fileID);
    for i = 1:length(means{1})
        rpm(i) = means{1}(i);
        collectives(i) = means{2}(i);
        filenames{i} = string(means{8}(i));
    end
else
    fprintf('ERROR. File does not exist\n')
end

for i = 1:length(filenames)
    if isfile(fullfile(Exp_data_dir,filenames{i}))
        fprintf(strcat(filenames{i},'...\n'));
        sData = csvread(fullfile(Exp_data_dir,filenames{i}));
        
        %current1
        I1{i} = sData(:,16); I1_avg(i) = mean(sData(:,16)); 
        I1_c95(i) = std(sData(:,16))/sqrt(length(sData(:,16)))*1.96;
        I1err(i) = sqrt(I1_c95(i)^2 + I_b^2);
        
        %current2
        I2{i} = sData(:,17); I2_avg(i) = mean(sData(:,17));
        I2_c95(i) = std(sData(:,17))/sqrt(length(sData(:,17)))*1.96;
        I2err(i) = sqrt(I2_c95(i)^2 + I_b^2);
         
        %thrust (upper AND lower rotors)
        T1{i} = sData(:,3); T1_avg(i) = -1*mean(T1{i});
        T2{i} = sData(:,9); T2_avg(i) = mean(T2{i});
        T_avg(i) = T1_avg(i) + T2_avg(i);
        T1_c95(i) = std(T1{i})/sqrt(length(T1{i}))*1.96; T1_err(i) = sqrt(T1_c95(i)^2 + T_b^2);
        T2_c95(i) = std(T2{i})/sqrt(length(T2{i}))*1.96; T2_err(i) = sqrt(T2_c95(i)^2 + T_b^2);
        T_err(i) = T1_err(i) + T2_err(i);
        
        %torque
        Q1{i} = sData(:,6); Q1_avg(i) = -1*mean(Q1{i});
        Q2{i} = sData(:,12); Q2_avg(i) = mean(Q2{i});
        Q_avg(i) = Q1_avg(i) + Q2_avg(i);
        Q1_c95(i) = std(Q1{i})/sqrt(length(Q1{i}))*1.96; 
        Q1_err(i) = sqrt(Q1_c95(i)^2 + Q_b^2);
        Q2_c95(i) = std(Q2{i})/sqrt(length(Q2{i}))*1.96;
        Q2_err(i) = sqrt(Q2_c95(i)^2 + Q_b^2);
        Q_err(i) = Q1_err(i) + Q2_err(i);
        
        %blade loading (Ct/sigma = BL)
        BL(i) = T_avg(i)/rho/A/(rpm(i)*2*pi/60*R)^2/sigma;
        BL_err(i) = T_err(i)/rho/A/(rpm(i)*2*pi/60*R)^2/sigma;
        
    else
        fprintf('ERROR. File does not exist\n')
    end
end

%bias currents at 61 RPM
% bias = input('Bias Currents? [y/n]: ','s');
% if bias == 'y'
%     I10 = mean([I1_avg(1) I1_avg(end)]);
%     I20 = mean([I2_avg(1) I2_avg(end)]);
% elseif bias == 'n'
%     I10 = 0;
%     I20 = 0;
% end
I10 = 0;
I20 = 0;
I1_avg = I1_avg - I10;
I2_avg = I2_avg - I20;

rounded_rpm = round(rpm,-2); %round rpm to hundreds place
idx = find(rounded_rpm == str2double(RPM)); %index the max rpm in the data set

P_elec = V_bus*I1_avg; P_elec_err = V_bus*I1err;%electrical power
P_rotor = Q_avg.* rpm/60*2*pi; P_rotor_err = Q_err.*rpm/60*2*pi; %rotor power
eta_mech = P_rotor./P_elec; %mechanical efficiency
eta_mech_err = ((1./P_elec.*P_rotor_err).^2 + (-P_rotor./P_elec.^2.*P_elec_err).^2).^0.5; 

%% Plot data
xlimits = [min(collectives) max(collectives)];

%Current vs Collective
figure
hold on
plot(collectives(idx),I1_avg(idx),'^','linewidth',1.5,'Color',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.I,'k--','linewidth',1.5)
errorbar(collectives(idx),I1_avg(idx),I1err(idx),I1err(idx),'.','Color',colors{2})
title(strcat('Current vs Collective ($\theta_o$) (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Current, A','interpreter','latex')
legend('UB+','BEMT','location','best')
xlim(xlimits)
formatfig
hold off

%Current vs BL
figure
hold on
plot(BL(idx),I1_avg(idx),'^','linewidth',1.5,'Color',colors{2})
plot(analytical_data.BL,analytical_data.I,'k--','linewidth',1.5)
errorbar(BL(idx),I1_avg(idx),I1err(idx),I1err(idx),BL_err(idx),BL_err(idx),'.','Color',colors{2})
title(strcat('Current vs Blade Loading (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Blade Loading ($\frac{C_T}{\sigma}$)','interpreter','latex')
ylabel('Current, A','interpreter','latex')
legend('UB+','BEMT','location','best')
formatfig
hold off

%BL vs Collective
figure
hold on
plot(collectives(idx),BL(idx),'^','linewidth',1.5,'Color',colors{2})
% plot(analytical_data.t_sweep*180/pi,analytical_data.BL,'k--','linewidth',1.5)
errorbar(collectives(idx),BL(idx),BL_err(idx),'.','Color',colors{2})
title(strcat('Blade Loading vs Collective (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Blade Loading ($C_T/\sigma$)','interpreter','latex')
% legend('Measured','BEMT','location','best')
xlim(xlimits);
formatfig
hold off

%T vs Collective
figure
hold on
plot(collectives(idx),T_avg(idx),'^','linewidth',1.5,'Color',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.T,'k--','linewidth',1.5)
errorbar(collectives(idx),T_avg(idx),T_err(idx),'.','Color',colors{2})
title(strcat('Thrust vs Collective (',strrep(filename,'_',' '),')'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Thrust, N','interpreter','latex')
legend('Measured','BEMT','location','best')
xlim(xlimits);
formatfig
hold off

%Q vs Collective
figure
hold on
plot(collectives(idx),Q_avg(idx),'^','linewidth',1.5,'Color',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.Qrotor,'k--','linewidth',1.5)
errorbar(collectives(idx),Q_avg(idx),Q_err(idx),'.','Color',colors{2})
title(strcat('Rotor Torque vs Collective (',strrep(filename,'_',' '),')'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Torque, N-m','interpreter','latex')
legend('Measured','BEMT','location','best')
xlim(xlimits);
formatfig
hold off

%Protor vs Collective
figure
hold on
plot(collectives(idx),P_rotor(idx),'^','linewidth',1.5,'Color',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.P,'k--','linewidth',1.5)
errorbar(collectives(idx),P_rotor(idx),P_rotor_err(idx),'.','Color',colors{2})
title(strcat('Power Output vs Collective (',strrep(filename,'_',' '),')'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Power, W','interpreter','latex')
legend('Measured','BEMT','location','best')
xlim(xlimits);
formatfig
hold off

%Efficiency vs Collective
figure
hold on
plot(collectives(idx),eta_mech(idx),'^','linewidth',1.5,'Color',colors{2})
errorbar(collectives(idx),eta_mech(idx),eta_mech_err(idx),'.','Color',colors{2})
title(strcat('Efficiency vs Collective (',strrep(filename,'_',' '),')'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Efficiency $\eta$, \%','interpreter','latex')
legend('Measured','location','best')
xlim(xlimits);
formatfig
hold off

%% Saving
save_prompt = input('Save Data? [y/n]:','s');
if save_prompt == 'y'
%     filename = strcat('GITHUB_BEMT--',filename);
    fname = strcat(filename,'--',RPM,'RPM_',string(Nb),'bladed_',string(min(collectives)),...
        '-',string(max(collectives)),'deg'); %.mat file name
    
    
    dir   = '/Users/asper101/Box Sync/Matt Lab Stuff/Stacked Rotor/Data Processing';
    fpath = strcat(dir,'/',filename); % directory to save all data

    [status, msg] = mkdir(dir,filename); % make directory
    
    save(fullfile(fpath,fname)); % save .mat file
    
    %save figures
    saveas(figure(1),fullfile(fpath,'Current vs Collective'),'jpeg');
    saveas(figure(2),fullfile(fpath,'Current vs Blade Loading'),'jpeg');
    saveas(figure(3),fullfile(fpath,'Blade Loading vs Collective'),'jpeg');
    saveas(figure(4),fullfile(fpath,'Thrust vs Collective'),'jpeg');
    saveas(figure(5),fullfile(fpath,'Rotor Torque vs Collective'),'jpeg');
    saveas(figure(6),fullfile(fpath,'Power Output vs Collective'),'jpeg');
    saveas(figure(7),fullfile(fpath,'Mechanical Efficiency vs Collective'),'jpeg');
end

function formatfig
fontsize = 20;
set(0,'defaultaxesfontsize',fontsize);
set(0,'defaulttextInterpreter','latex')
grid on
end

