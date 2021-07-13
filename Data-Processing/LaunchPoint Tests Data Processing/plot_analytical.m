function plot_analytical(idx,collectives, I1_avg,I2_avg,I1err,I2err,...
    analytical_data,T_avg,T_err,BL,BL_err,Q_avg,Q_err,P_rotor,P_rotor_err,eta_mech,...
    eta_mech_err,colors,filename,xlimits,RPM,Nb)
close all

%Plot data with analytical predictions

%Current vs Collective
figure('Name','Current vs Collective'); f1 = gcf;
hold on
errorbar(collectives(idx),I1_avg(idx),I1err(idx),I1err(idx),'^','Color',colors{2},'MarkerFaceColor',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.I,'k--','linewidth',1.5)
title(strcat('Current vs Collective ($\theta_o$) (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Current, A','interpreter','latex')
legend('UB+','BEMT','location','best')
xlim(xlimits)
formatfig
hold off

%Current vs BL
figure('Name','Current vs Blade Loading'); f2 = gcf;
hold on
errorbar(BL(idx),I1_avg(idx),I1err(idx),I1err(idx),BL_err(idx),BL_err(idx),'^','Color',colors{2},'MarkerFaceColor',colors{2})
plot(analytical_data.BL,analytical_data.I,'k--','linewidth',1.5)
title(strcat('Current vs Blade Loading (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Blade Loading ($\frac{C_T}{\sigma}$)','interpreter','latex')
ylabel('Current, A','interpreter','latex')
legend('UB+','BEMT','location','best')
formatfig
hold off

%BL vs Collective
figure('Name','Blade Loading vs Collective'); f3 = gcf;
hold on
errorbar(collectives(idx),BL(idx),BL_err(idx),'^','Color',colors{2},'MarkerFaceColor',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.BL,'k--','linewidth',1.5)
title(strcat('Blade Loading vs Collective (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Blade Loading ($C_T/\sigma$)','interpreter','latex')
legend('Measured','BEMT','location','best')
xlim(xlimits);
formatfig
hold off

%T vs Collective
figure('Name','Thrust vs Collective'); f4 = gcf;
hold on
errorbar(collectives(idx),T_avg(idx),T_err(idx),'^','Color',colors{2},'MarkerFaceColor',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.T,'k--','linewidth',1.5)
title(strcat('Thrust vs Collective (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Thrust, N','interpreter','latex')
legend('Measured','BEMT','location','best')
xlim(xlimits);
formatfig
hold off

%Q vs Collective
figure('Name','Measured Torque Cell Torque'); f5 = gcf;
hold on
errorbar(collectives(idx),Q_avg(idx),Q_err(idx),'^','Color',colors{2},'MarkerFaceColor',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.Qrotor,'k--','linewidth',1.5)
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Torque, N-m','interpreter','latex')
legend('Measured','BEMT','location','best')
xlim(xlimits);
formatfig
hold off

%Protor vs Collective
figure('Name','Measured Rotor Power'); f6 = gcf;
hold on
errorbar(collectives(idx),P_rotor(idx),P_rotor_err(idx),'^','Color',colors{2},'MarkerFaceColor',colors{2})
plot(analytical_data.t_sweep*180/pi,analytical_data.P,'k--','linewidth',1.5)
title(strcat('Torque Cell Power vs Collective (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Power, W','interpreter','latex')
legend('Measured','BEMT','location','best')
xlim(xlimits);
formatfig
hold off

%Efficiency vs Collective
figure('Name','Mechanical Efficiency vs Collective'); f7 = gcf;
hold on
errorbar(collectives(idx),eta_mech(idx),eta_mech_err(idx),'^','Color',colors{2},'MarkerFaceColor',colors{2})
title(strcat('Efficiency vs Collective (',RPM,' RPM/',string(Nb),...
    '-bladed)'),'interpreter','latex')
xlabel('Collective ($\theta_o$), deg','interpreter','latex')
ylabel('Efficiency $\eta$, \%','interpreter','latex')
legend('Measured','location','best')
xlim(xlimits);
formatfig
hold off


%% Saving
save_prompt = input('Save Data? [y/n]:','s');
if save_prompt == 'y'
    fname = strcat(filename,'--',RPM,'RPM_',string(Nb),'bladed_',string(min(collectives)),...
        '-',string(max(collectives)),'deg'); %.mat file name
    
    
    dir   = pwd;
    fpath = strcat(dir,strcat('/',filename,'/w Analytical')); % directory to save all data

    [status, msg] = mkdir(dir,strcat(filename,'/w Analytical')); % make directory
    
    save(fullfile(fpath,fname)); % save .mat file
    
    %save figures
    saveas(f1,fullfile(fpath,'Current vs Collective'),'jpeg');
    saveas(f2,fullfile(fpath,'Current vs Blade Loading'),'jpeg');
    saveas(f3,fullfile(fpath,'Blade Loading vs Collective'),'jpeg');
    saveas(f4,fullfile(fpath,'Thrust vs Collective'),'jpeg');
    saveas(f5,fullfile(fpath,'Torque Cell Torque'),'jpeg');
    saveas(f6,fullfile(fpath,'Torque Cell Power'),'jpeg');
    saveas(f7,fullfile(fpath,'Mechanical Efficiency vs Collective'),'jpeg');
end



end


function formatfig
fontsize = 20;
set(0,'defaultaxesfontsize',fontsize);
set(0,'defaulttextInterpreter','latex')
set(0,'defaultlegendinterpreter','latex')
set(0,'defaultAxesTickLabelInterpreter','latex')
grid on
end


