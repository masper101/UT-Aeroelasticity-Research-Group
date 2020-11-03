%plot phase avg loads
load('colors.mat')
i = 11;

figure('Position', [10 10 600 600])
subplot(3,1,1)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fx_outer{i}-RevData.avg_Fx_outer{1}, RevData.err_Fx_outer{i}, colors{1})
ylabel('F_x [N]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,2)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fy_outer{i}-RevData.avg_Fy_outer{1}, RevData.err_Fy_outer{i}, colors{1})
ylabel('F_y [N]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,3)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fz_outer{i}-RevData.avg_Fz_outer{1}, RevData.err_Fz_outer{i}, colors{1})
ylabel('F_z [N]')
xlabel('Azimuth [deg]')
grid on
xlim([0,360])

figure('Position', [10 10 600 600])
subplot(3,1,1)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Mx_outer{i}-RevData.avg_Mx_outer{1}, RevData.err_Mx_outer{i}, colors{1})
ylabel('M_x [N-m]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,2)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_My_outer{i}-RevData.avg_My_outer{1}, RevData.err_My_outer{i}, colors{1})
ylabel('M_y [N-m]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,3)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Mz_outer{i}-RevData.avg_Mz_outer{1}, RevData.err_Mz_outer{i}, colors{1})
ylabel('M_z [N-m]')
xlabel('Azimuth [deg]')
grid on
xlim([0,360])

%plot phase avg loads
load('colors.mat')
i =5;

figure('Position', [10 10 600 600])
subplot(3,1,1)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fx_inner{i}, RevData.err_Fx_inner{i}, colors{1})
ylabel('F_x [N]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,2)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fy_inner{i}, RevData.err_Fy_inner{i}, colors{1})
ylabel('F_y [N]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,3)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fz_inner{i}, RevData.err_Fz_inner{i}, colors{1})
ylabel('F_z [N]')
xlabel('Azimuth [deg]')
grid on
xlim([0,360])

figure('Position', [10 10 600 600])
subplot(3,1,1)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Mx_inner{i}, RevData.err_Mx_inner{i}, colors{1})
ylabel('M_x [N-m]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,2)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_My_inner{i}, RevData.err_My_inner{i}, colors{1})
ylabel('M_y [N-m]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,3)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Mz_inner{i}, RevData.err_Mz_inner{i}, colors{1})
ylabel('M_z [N-m]')
xlabel('Azimuth [deg]')
grid on
xlim([0,360])

