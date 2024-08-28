figure;

% 绘制磁暴时期（storm）
errorbar(p(p_begin:p_end), Normvector(z_storm_list(p_begin:p_end,:), 1, 2), Normvector(z_storm_err_list(p_begin:p_end,:), 1, 2), 'Color', [1 0 0], 'LineWidth', 1.5);
hold on;

% 绘制相干阈值0.75筛选（coh）
errorbar(p(p_begin:p_end), Normvector(z_coh_list(p_begin:p_end,:), 1, 2), Normvector(z_coh_err_list(p_begin:p_end,:), 1, 2), 'Color', [0 1 0], 'LineWidth', 1.5);
hold on;

% 绘制小波多频段筛选（ok）
errorbar(p(p_begin:p_end), Normvector(z_ok_list(p_begin:p_end,:), 1, 2), Normvector(z_ok_err_list(p_begin:p_end,:), 1, 2), 'Color', [0 0 0], 'LineWidth', 1.5);

% 设置轴标签
xlabel('周期（s）', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('阻抗幅值', 'FontSize', 12, 'FontWeight', 'bold');

% 添加图例
legend({'磁暴时期（storm）', '相干阈值0.75筛选（coh）', '小波多频段筛选（ok）'}, 'FontSize', 12, 'Location', 'best');

% 添加网格线
grid on;

% 设置图形标题
title('不同筛选条件下的阻抗幅值变化', 'FontSize', 14, 'FontWeight', 'bold');

% 设置图形框架
box on;

% 设置字体
set(gca, 'FontSize', 12, 'FontWeight', 'bold');

hold off;


figure;

% 绘制磁暴时期（storm）
errorbar(p(p_begin:p_end), angle_storm(p_begin:p_end), angle_storm_err(p_begin:p_end), 'Color', [1 0 0], 'LineWidth', 1.5);
hold on;

% 绘制相干阈值0.75筛选（coh）
errorbar(p(p_begin:p_end), angle_coh(p_begin:p_end), angle_coh_err(p_begin:p_end), 'Color', [0 1 0], 'LineWidth', 1.5);
hold on;

% 绘制小波多频段筛选（ok）
errorbar(p(p_begin:p_end), angle_ok(p_begin:p_end), angle_ok_err(p_begin:p_end), 'Color', [0 0 0], 'LineWidth', 1.5);

% 设置轴标签
xlabel('周期（s）', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('角度（度）', 'FontSize', 12, 'FontWeight', 'bold');

% 添加图例
legend({'磁暴时期（storm）', '相干阈值0.75筛选（coh）', '小波多频段筛选（ok）'}, 'FontSize', 12, 'Location', 'best');

% 添加网格线
grid on;

% 设置图形标题
title('不同筛选条件下的角度变化', 'FontSize', 14, 'FontWeight', 'bold');

% 设置图形框架
box on;

% 设置字体
set(gca, 'FontSize', 12, 'FontWeight', 'bold');

hold off;
