% 创建一个新的图形窗口
figure('Name', 'PCA降维后数据散点图', 'NumberTitle', 'off');

% 创建一个 tiledlayout，用于排列子图
tiledlayout(5, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');

for i = 1:5
    % 创建一个新的子图
    ax1 = nexttile;
    
    % 绘制第 i 个降维后数据的散点图
    scatter(Time_list, X_decomposed(:,i), 'k.');
    
    % 设置子图的标题
    title(['PCA 主成分 ' num2str(i)], 'FontSize', 12, 'FontWeight', 'bold');
    
    % 设置轴标签
    xlabel('时间（s）', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('信号幅值', 'FontSize', 12, 'FontWeight', 'bold');
    
    % 添加网格线
    grid on;
    
    % 设置轴的字体
    set(gca, 'FontSize', 12, 'FontWeight', 'bold');
end

% 设置整体图形的标题
sgtitle('PCA降维后的数据散点图', 'FontSize', 14, 'FontWeight', 'bold');
