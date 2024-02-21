function [Imp, err] = ImpedancePlotter(Imp, err, freq)
%IMPEDANCEPLOTTER 此处显示有关此函数的摘要
%   此处显示详细说明
if(~exist('freq','var'))
    periods = py.numpy.logspace(1, 4, int8(20));
    freq = double(1 / periods);  % 如果未出现该变量，则对其进行赋值
end
periods = 1./freq;
rho = zeros(length(periods), 2, 2);
rho_err = zeros(length(periods), 2, 2);
rho(:, 1, 2) = 0.2 * periods' .* Imp(:, 1, 2).^2;
rho(:, 2, 1) = 0.2 * periods' .* Imp(:, 2, 1).^2;
rho(:, 1, 1) = 0.2 * periods' .* Imp(:, 1, 1).^2;
rho(:, 2, 2) = 0.2 * periods' .* Imp(:, 2, 2).^2;
rho_err(:, 1, 2) = 0.2 * periods' .* err(:, 1, 2).^2;
rho_err(:, 2, 1) = 0.2 * periods' .* err(:, 2, 1).^2;
rho_err(:, 1, 1) = 0.2 * periods' .* err(:, 1, 1).^2;
rho_err(:, 2, 2) = 0.2 * periods' .* err(:, 2, 2).^2;


figure(1)
errorbar(periods, abs(rho(:,1,1)), rho_err(:,1,1),'m');
set(gca, 'yscale', 'log');
set(gca, 'xscale', 'log');
xlim([10 10000]);
ylim([0 10^5]);
hold on;

errorbar(periods, abs(rho(:,1,2)), rho_err(:,1,2),'r');
set(gca, 'yscale', 'log');
set(gca, 'xscale', 'log');
ylim([0 10^5]);

hold on;
errorbar(periods, abs(rho(:,2,1)), rho_err(:,2,1),'b');
set(gca, 'yscale', 'log');
set(gca, 'xscale', 'log');
ylim([0 10^5]);

hold on;
errorbar(periods, abs(rho(:,2,2)), rho_err(:,2,2),'g');
set(gca, 'yscale', 'log');
set(gca, 'xscale', 'log');
ylim([0 10^5]);

legend('ρxx','ρxy','ρyx','ρyy','Fontsize',15)
xlabel('Period(s)','FontSize',20)
ylabel('Apparent Resistivity(Ω*m)','FontSize',20)

phi = angle(Imp);
phi = rad2deg(phi);
rad_err = asin(err./abs(Imp));
rad_err(isnan(rad_err)) = pi;
phi_err = rad2deg(rad_err);

figure(2)
errorbar(periods, phi(:,1,1), phi_err(:,1,1),'m');
set(gca, 'xscale', 'log');
ylim([-180 180]);

hold on;
errorbar(periods, phi(:,1,2), phi_err(:,1,2),'r');
set(gca, 'xscale', 'log');
ylim([-180 180]);

hold on;
errorbar(periods, phi(:,2,1), phi_err(:,2,1),'b');
set(gca, 'xscale', 'log');
ylim([-180 180]);
hold on;
errorbar(periods, phi(:,2,2), phi_err(:,2,2),'g');
set(gca, 'xscale', 'log');
ylim([-180 180]);
xlim([10 10000]);
legend('Φxx','Φxy','Φyx','Φyy','FontSize',15)
xlabel('Period(s)','FontSize',20)
ylabel('Phase(degree)','FontSize',20)
end

