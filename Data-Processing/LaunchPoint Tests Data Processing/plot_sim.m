function [f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12] = plot_sim(sim_data,t,rpm,rpm_err,T_avg,T_err,I_avg,I_err,...
    P_avg,P_err,P_elec,P_elec_err,eta,eta_err,Vbus,idx_az,colors,tstep,collective,Nb,dwdt,dwdt_err)
%This function plots the experimenal results against simulink predictions
close all;
GR = 1.6;

figure('Name','RPM vs Time'), f1 = gcf;
hold on
plot(sim_data.Speed_cmd.time - tstep,sim_data.Speed_cmd.data/GR,'k-','linewidth',1.5)
plot(sim_data.Rotor_RPM.time - tstep,sim_data.Rotor_RPM.data,'-','Color',colors{1},'linewidth',1.5)
plot_areaerrorbar(t(idx_az),rpm(2:end),rpm_err(2:end),colors{2})
xlabel('Time, s')
ylabel('Rotor Spped')
xlim([0 3])
legend('Commanded','Prediction','Experiment','location','best')
hold off
formatfig

figure('Name','Current vs Time'), f2 = gcf;
hold on
plot(sim_data.Bus_Current.time - tstep,sim_data.Bus_Current.data,'k-','linewidth',1.5)
plot_areaerrorbar(t(idx_az),I_avg,I_err,colors{1})
xlabel('Time, s')
ylabel('Current, A')
xlim([0 3])
% ylim([0 20])
legend('Prediction','Experiment','location','best')
hold off
formatfig

figure('Name','Thrust vs Time'), f3 = gcf;
hold on
plot(sim_data.Thrust.time - tstep,sim_data.Thrust.data,'k-','linewidth',1.5)
plot_areaerrorbar(t(idx_az),T_avg,T_err,colors{1})
xlabel('Time, s')
ylabel('Thrust, N')
xlim([0 3])
legend('Prediction','Experiment','location','best')
hold off
formatfig

figure('Name','Electrical Power vs Time'), f4 = gcf;
hold on
plot(sim_data.Bus_Current.time - tstep,sim_data.Bus_Current.data*Vbus,'k-','linewidth',1.5)
plot_areaerrorbar(t(idx_az),P_elec,P_elec_err,colors{1})
xlabel('Time, s')
ylabel('Power, W')
xlim([0 3])
legend('Prediction','Experiment','location','best')
hold off
formatfig

figure('Name','Torque Cell Power vs Time'), f5 = gcf;
hold on
plot(sim_data.P_rotor.time - tstep,sim_data.P_rotor.data,'k-','linewidth',1.5)
plot_areaerrorbar(t(idx_az),P_avg,P_err,colors{1})
xlabel('Time, s')
ylabel('Power, W')
xlim([0 3])
legend('Prediction','Experiment','location','best')
hold off
formatfig

%Current and Power Plot
figure('Name','Current and Rotor Power vs Time'), f6 = gcf;
hold on
yyaxis left
plot_areaerrorbar(t(idx_az),I_avg,I_err,colors{1})
ylabel('Current, A')

yyaxis right
plot_areaerrorbar(t(idx_az),P_avg,P_err,colors{2})
title(strcat('Current and Power vs Time ($\theta = ',collective,'^o$/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Time, s')
ylabel('Power, W')
xlim([0 3])
hold off
formatfig

figure('Name','Efficiency vs Time'), f7 = gcf;
hold on
plot(sim_data.eta_mech.time - tstep,sim_data.eta_mech.data,'k-','linewidth',1.5)
plot_areaerrorbar(t(idx_az),eta,eta_err,colors{1})
xlabel('Time, s')
ylabel('Efficiency ($\eta$)')
xlim([0 3])
legend('Prediction','Experiment','location','best')
hold off
formatfig

figure('Name','Inertial Power vs Time'), f8 = gcf;
hold on
plot(sim_data.P_inertia.time - tstep,sim_data.P_inertia.data,'Color',colors{1},'linewidth',1.5)
xlabel('Time, s')
ylabel('Inertial Power ($I\dot{\Omega}$), W')
xlim([0 3])
hold off
formatfig

figure('Name','Aerodynamic Power vs Time'), f9 = gcf;
hold on
plot(sim_data.P_aero.time - tstep,sim_data.P_aero.data,'Color',colors{1},'linewidth',1.5)
xlabel('Time, s')
ylabel('Aerodynamic Power ($Q\Omega$), W')
xlim([0 3])
hold off
formatfig

figure('Name','Angular Acceleration vs Time'), f10 = gcf;
hold on
plot(sim_data.dwdt_rotor.time - tstep,sim_data.dwdt_rotor.data,'k-','linewidth',1.5)
plot_areaerrorbar(t(idx_az),dwdt,dwdt_err,colors{1})
xlabel('Time, s')
ylabel('Acceleration ($\dot{\Omega}$), $\mathrm{rad/s^2}$')
xlim([0 3])
legend('Prediction','Experiment','location','best')
hold off
formatfig

figure('Name','Motor vs Rotor Torque vs Time'), f11 = gcf;
hold on
plot(sim_data.Q_total.time - tstep,sim_data.Q_total.data,'-','Color',colors{1},'linewidth',1.5)
plot(sim_data.Q_motor.time - tstep,sim_data.Q_motor.data,'-','Color',colors{2},'linewidth',1.5)
xlabel('Time, s')
ylabel('Torque, Nm')
xlim([0 3])
legend('Rotor','Motor','location','best')
hold off
formatfig

figure('Name','Motor vs Rotor Torque vs Time'), f12 = gcf;
hold on
plot(sim_data.Q_total.time - tstep,sim_data.Q_total.data,'-','Color',colors{1},'linewidth',1.5)
plot(sim_data.Q_rotor.time - tstep,sim_data.Q_rotor.data,'-','Color',colors{2},'linewidth',1.5)
plot(sim_data.Q_inertia.time - tstep,sim_data.Q_inertia.data,'-','Color',colors{3},'linewidth',1.5)
xlabel('Time, s')
ylabel('Torque, Nm')
xlim([0 3])
legend('Total','Aerodynamic','Inertial','location','best')
hold off
formatfig

end

%% Functions
function formatfig
fontsize = 20;
set(0,'defaultaxesfontsize',fontsize);
set(0,'defaulttextInterpreter','latex')
set(0,'defaultlegendinterpreter','latex')
set(0,'defaultAxesTickLabelInterpreter','latex')
grid on
end
