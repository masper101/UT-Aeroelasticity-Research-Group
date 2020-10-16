%plot phase avg loads
load('colors.mat')
i = 10;

figure('Position', [10 10 600 600])
subplot(3,1,1)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fx_outer{i}, RevData.err_Fx_outer{i}, colors{1})
ylabel('F_x [N]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,2)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fy_outer{i}, RevData.err_Fy_outer{i}, colors{1})
ylabel('F_y [N]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,3)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Fz_outer{i}, RevData.err_Fz_outer{i}, colors{1})
ylabel('F_z [N]')
xlabel('Azimuth [deg]')
grid on
xlim([0,360])

figure('Position', [10 10 600 600])
subplot(3,1,1)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Mx_outer{i}, RevData.err_Mx_outer{i}, colors{1})
ylabel('M_x [N-m]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,2)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_My_outer{i}, RevData.err_My_outer{i}, colors{1})
ylabel('M_y [N-m]')
xlabel('Azimuth [deg]')
xlim([0,360])
grid on

subplot(3,1,3)
plot_confidenceint(SortedData.azimuth{i}, RevData.avg_Mz_outer{i}, RevData.err_Mz_outer{i}, colors{1})
ylabel('M_z [N-m]')
xlabel('Azimuth [deg]')
grid on
xlim([0,360])
