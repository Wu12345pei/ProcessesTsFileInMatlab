% 创建一个新的图形窗口
figure;
% 绘制散点图，增加颜色和大小
scatter(Time_list(timepoint_index_selected), X_decomposed(timepoint_index_selected, 1), ...
        'filled', 'MarkerFaceColor', [0 0.4470 0.7410], 'MarkerEdgeColor', 'b', 'SizeData', 100);

% 增加标题和轴标签
title('Selected Time Points Visualization', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Decomposed Value', 'FontSize', 12, 'FontWeight', 'bold');

% 添加网格线
grid on;

% 设置轴和图标的字体大小
set(gca, 'FontSize', 12, 'FontWeight', 'bold');

% 自动调整轴限制以适应数据
axis tight;
