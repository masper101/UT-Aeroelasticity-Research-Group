function ss_process(AvgData,MeanData,filename,RPM,Nb,V_bus,colors)
%This function plots the steady state-processed data

%% Load analytical comparison

fprintf('Select Analytical Prediction File to Load...\n');
[analytical_file,analytical_path] = uigetfile(strcat('/Users/asper101/Box Sync/',...
    'Matt Lab Stuff/Electromechanical Modelling/Analytical Modelling'));
analytical_data = load(fullfile(analytical_path,analytical_file));

%% Get data in original format

%Get idx of collectives
idx = find(round(MeanData.RPMs,0) == str2double(RPM));
collectives = MeanData.meancols;
xlimits = [min(collectives) max(collectives)];
    

I1_avg = cell2mat(AvgData.curr1); I2_avg = cell2mat(AvgData.curr2); 
I1err = cell2mat(AvgData.err_curr1); I2err = cell2mat(AvgData.err_curr2);
BL = cell2mat(AvgData.avg_cts_outer) + cell2mat(AvgData.avg_cts_inner);
BL_err = cell2mat(AvgData.err_cts_outer) + cell2mat(AvgData.err_cts_inner);

T_avg = cell2mat(AvgData.Ttot); T_err = cell2mat(AvgData.err_Ttot);
Q_avg = cell2mat(AvgData.Qtot); Q_err = cell2mat(AvgData.err_Qtot);
P_avg = cell2mat(AvgData.Ptot); P_err = cell2mat(AvgData.err_Ptot);


%Calc mechanical efficiency
P_elec = V_bus*I1_avg; P_elec_err = V_bus*I1err;%electrical power
P_rotor = P_avg; P_rotor_err = P_err; %rotor power
eta_mech = P_rotor./P_elec; %mechanical efficiency
eta_mech_err = ((1./P_elec.*P_rotor_err).^2 + (-P_rotor./P_elec.^2.*P_elec_err).^2).^0.5; 

%% Plot data and saving

%plot with analytical data?
plot_analyt = input('Plot with analytical data? [y/n]: ','s');
if plot_analyt == 'y'
    plot_analytical(idx,collectives, I1_avg,I2_avg,I1err,I2err,...
    analytical_data,T_avg,T_err,BL,BL_err,Q_avg,Q_err,P_rotor,P_rotor_err,eta_mech,eta_mech_err,...
    colors,filename,xlimits,RPM,Nb);
else
    plot_exp(idx,collectives, I1_avg,I2_avg,I1err,I2err,...
    analytical_data,T_avg,T_err,BL,BL_err,Q_avg,Q_err,P_rotor,P_rotor_err,eta_mech,eta_mech_err,...
    colors,filename,xlimits,RPM,Nb);
end

end

