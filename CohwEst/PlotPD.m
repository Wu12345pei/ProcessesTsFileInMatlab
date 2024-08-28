% Initialize figure and tiled layout for two subplots
figure;
tiledlayout(2,1, 'TileSpacing', 'compact', 'Padding', 'compact');

% First subplot for polarization states
ax1 = nexttile;
scatter(data_all(:,8), PD_E, 80, 'k', 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'k', 'DisplayName', 'Electric Field');
hold on;
scatter(data_all(:,8), PD_H, 80, 'r', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'DisplayName', 'Magnetic Field');
xlabel('Time (s)');
ylabel('Polarization State');
legend('Location', 'northeastoutside');  % Place legend outside the plot area to save space
title('Polarization States over Time');
grid on; % Turn on the grid

% Second subplot for log of impedance
ax2 = nexttile;
scatter(reliable_data_to_plot(:,8), log(reliable_data_to_plot(:,6)), 80, 'r', 'filled', 'DisplayName', 'Reliable Data');
hold on;
scatter(unreliable_data_to_plot(:,8), log(unreliable_data_to_plot(:,6)), 80, 'k', 'filled', 'DisplayName', 'Unreliable Data');
xlabel('Time (s)');
ylabel('Log(Impedance)');
legend('Location', 'northeastoutside');  % Place legend outside the plot area to save space
title('Log of Impedance over Time');
grid on; % Turn on the grid

% Define x-axis limits based on the 'Time_list' to synchronize the time scales
xlim(ax2, [min(Time_list) max(Time_list)]);

% Link x-axes of both subplots for synchronized scrolling and zooming
linkaxes([ax1, ax2], 'x');

% Enhance visual style
set(gcf, 'Color', 'w'); % Set figure background to white
set([ax1, ax2], 'FontSize', 12, 'LineWidth', 1.5); % Set font size and line width for axes
