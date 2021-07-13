function transient_process(RevData,t,idx_az,V_bus,colors,Nb)

%This function plots and saves transient data
I_avg = cell2mat(RevData.ms_curr1); I_err = cell2mat(RevData.err_ms_curr1);
T_avg = cell2mat(RevData.ms_Ttot); T_err = cell2mat(RevData.err_ms_Ttot);
Q_avg = cell2mat(RevData.ms_Qtot); Q_err = cell2mat(RevData.err_ms_Qtot);
P_avg = cell2mat(RevData.ms_Ptot); P_err = cell2mat(RevData.err_ms_Ptot);
rpm = cell2mat(RevData.ms_instRPM); rpm_err = cell2mat(RevData.err_ms_instRPM);
idx_az = cell2mat(idx_az);
for i = 1:(length(idx_az)-1)
    dt = t(idx_az(i+1)) - t(idx_az(i));
    dw = (rpm(i+1) - rpm(i))*2*pi/60;
    dwdt(i) = dw/dt; dwdt_err(i) = sqrt(rpm_err(i)^2 + rpm_err(i+1)^2)*2*pi/60;
end
dwdt(i+1) = dwdt(end); dwdt_err(i+1) = dwdt_err(end);

P_elec = I_avg*V_bus; P_elec_err = V_bus*I_err;
eta = P_avg./P_elec;
eta_err = ((1./P_elec.*P_err).^2 + (-P_avg./P_elec.^2.*P_elec_err).^2).^0.5; 

%% Plotting
fprintf('Select Simulink File to Load...\n');
[sim_file,sim_path] = uigetfile(strcat('/Users/asper101/Box Sync/Matt Lab Stuff/',...
    'Electromechanical Modelling/Custom Models/Modified LaunchPoint/Rev6 Data'));
sim_data = load(fullfile(sim_path,sim_file));

tstep      = input('Step time [s]: ');                                      %step location of simulink [s]


%Plot experimental vs simulink
collective = input('Collective [deg]: ','s');

[f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12] = plot_sim(sim_data,t,rpm,rpm_err,T_avg,T_err,I_avg,I_err,...
    P_avg,P_err,P_elec,P_elec_err,eta,eta_err,V_bus,idx_az,colors,tstep,collective,Nb,dwdt,dwdt_err);

%% Saving
save_prompt = input('Save Data? [y/n]:','s');
if save_prompt == 'y'
    fname = input('Filename (#bladed_#-#RPM_#Deg): ','s'); % file name
    
    
    dir   = pwd;
    fpath = strcat(dir,'/',fname); % directory to save all data

    [status, msg] = mkdir(dir,fname); % make directory
        
    %save figures
    saveas(f1,fullfile(fpath,'RPM vs Time'),'jpeg');
    saveas(f2,fullfile(fpath,'Current vs Time'),'jpeg');
    saveas(f3,fullfile(fpath,'Thrust vs Time'),'jpeg');
    saveas(f4,fullfile(fpath,'Electrical Power vs Time'),'jpeg');
    saveas(f5,fullfile(fpath,'Torque Cell Power vs Time'),'jpeg');
    saveas(f6,fullfile(fpath,'Current and Torque Cell Power vs Time'),'jpeg');
    saveas(f7,fullfile(fpath,'Mechanical Efficiency vs Time'),'jpeg');
    saveas(f8,fullfile(fpath,'Inertial Power vs Time'),'jpeg');
    saveas(f9,fullfile(fpath,'Aerodynamic Power vs Time'),'jpeg');
    saveas(f10,fullfile(fpath,'Angular Acceleration vs Time'),'jpeg');
    saveas(f11,fullfile(fpath,'Rotor and Motor Torque vs Time'),'jpeg');
    saveas(f12,fullfile(fpath,'Rotor Torques vs Time'),'jpeg');
    
end



