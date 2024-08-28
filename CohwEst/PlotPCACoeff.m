% 创建一个新的图形窗口并设置标题
figure('Name', 'PCA系数图', 'NumberTitle', 'off');

% 创建一个 tiledlayout，用于排列子图
tiledlayout(2, 3, 'TileSpacing', 'Compact', 'Padding', 'Compact');

for i = 1:5
    % 创建一个新的子图
    ax1 = nexttile;
    
    % 绘制第 i 个系数的曲线
    plot(coeff(:,i), 'LineWidth', 1.5);
    
    % 设置子图的标题
    title(['第' num2str(i) '个主成分'], 'FontSize', 12, 'FontWeight', 'bold');
    
    % 设置轴标签
    xlabel('第i个周期', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('系数', 'FontSize', 12, 'FontWeight', 'bold');
    
    % 添加网格线
    grid on;
    
    % 设置轴的字体
    set(gca, 'FontSize', 12, 'FontWeight', 'bold');
end

% 设置整体图形的标题
sgtitle('PCA系数图', 'FontSize', 14, 'FontWeight', 'bold');
