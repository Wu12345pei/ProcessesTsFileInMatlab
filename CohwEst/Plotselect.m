% 创建一个新的图形窗口
figure('Name', '数据阈值分割散点图');

% 设定阈值
CV_thresthhold = 0.3;

% 计算滑动平均和其标准差
X_decomposed_moving_avg = movmean(X_decomposed(:,1), 10 * coherence_window_L);

% 计算差异
X_diff = X_decomposed(:,1) - X_decomposed_moving_avg;

% 创建一个 tiledlayout，用于排列子图
tiledlayout(4, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');

% 绘制第一幅图
ax1 = nexttile;
scatter(Time_list(CV > CV_thresthhold), X_decomposed(CV > CV_thresthhold, 1), 'k.', 'DisplayName', 'CV > Threshold', 'SizeData', 60);
hold on;
scatter(Time_list(CV <= CV_thresthhold), X_decomposed(CV <= CV_thresthhold, 1), 'r.', 'DisplayName', 'CV <= Threshold', 'SizeData', 60);
hold off;
title('CV 分割散点图', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('时间（s）', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('主成分1', 'FontSize', 14, 'FontWeight', 'bold');
legend('show', 'Location', 'best');
grid on;

% 绘制第二幅图
ax2 = nexttile;
scatter(Time_list(coherence_this_period >= coh_threshold), X_decomposed(coherence_this_period >= coh_threshold, 1), 'r.', 'DisplayName', 'Coherence >= Threshold', 'SizeData', 60);
hold on;
scatter(Time_list(coherence_this_period < coh_threshold), X_decomposed(coherence_this_period < coh_threshold, 1), 'k.', 'DisplayName', 'Coherence < Threshold', 'SizeData', 60);
hold off;
title('Coherence 分割散点图', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('时间（s）', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('主成分1', 'FontSize', 14, 'FontWeight', 'bold');
legend('show', 'Location', 'best');
grid on;

% 绘制第三幅图
ax3 = nexttile;
scatter(Time_list, X_decomposed(:,1), 'r.', 'DisplayName', 'Original', 'SizeData', 60);
hold on;
plot(Time_list, X_decomposed_moving_avg, 'k', 'DisplayName', 'Moving Average', 'LineWidth', 2);
title('滑动平均与原数值', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('时间（s）', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('主成分1', 'FontSize', 14, 'FontWeight', 'bold');
legend('show', 'Location', 'best');
grid on;

% 绘制第四幅图
ax4 = nexttile;
select_list_plus = zeros(length(Time_list), 1);
select_list_plus(coherence_this_period >= coh_threshold) = select_list_plus(coherence_this_period >= coh_threshold) + 1;
select_list_plus(CV <= CV_thresthhold) = select_list_plus(CV <= CV_thresthhold) + 1;
select_list_plus(X_diff <= 0) = select_list_plus(X_diff <= 0) + 1;
scatter(Time_list(select_list_plus ~= 3), X_decomposed(select_list_plus ~= 3, 1), 'k.', 'DisplayName', 'Non-selected', 'SizeData', 60);
hold on;
scatter(Time_list(select_list_plus == 3), X_decomposed(select_list_plus == 3, 1), 'r.', 'DisplayName', 'Selected', 'SizeData', 60);
% xline(Data_hxey(Data_hxey(:,6)<1.1*abs(z_storm(1)+1i*z_storm(2)),8),'HandleVisibility', 'off',Color=[1 0 0]);
% xline(Data_hxey(Data_hxey(:,6)>=1.1*abs(z_storm(1)+1i*z_storm(2)),8),'HandleVisibility', 'off',Color=[0 0 0]);
title('综合条件分割散点图', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('时间（s）', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('主成分1', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
legend('show', 'Location', 'best');
linkaxes([ax1 ax2 ax3 ax4],'xy')


