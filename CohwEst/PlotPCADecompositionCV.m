% 创建一个新的图形窗口并设置标题
figure('Name', 'PCA降维后数据散点图', 'NumberTitle', 'off');

% 创建一个 tiledlayout，用于排列子图

% 创建子图并绘制散点图
scatter(Time_list, X_decomposed(:,1), [], Volatility(:,1), '.');
colorbar;
title('PCA 主成分 1', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('幅度', 'FontSize', 12, 'FontWeight', 'bold');
grid on;



% 设置所有子图的字体大小和粗细
