% 创建一个新的图形窗口
figure;

% 计算归一化磁场和电场数据
magnetic_field = Normvector(ok_data, 1, 2);
electric_field = Normvector(ok_data, 3, 4);

magnetic_field_coh = Normvector(Data_hxey, 1, 2);
electric_field_coh = Normvector(Data_hxey, 3, 4);


% 绘制散点图
scatter(magnetic_field_coh, electric_field_coh, 36, 'k', 'filled','DisplayName', 'selected by coherence'); % 增加点的大小并填充颜色
hold on;
scatter(magnetic_field, electric_field, 36, 'r', 'filled','DisplayName', 'selected by new method'); % 增加点的大小并填充颜色
hold on;
% 设定斜率 k
k = abs(z_storm(1)+1i*z_storm(2));  % 例如斜率为 2
% 选择一个 x 范围
x = linspace(0, max(magnetic_field_coh), 100);  % 从 -10 到 10
% 计算对应的 y 值
y = k * x;
plot(x, y, 'g-'); % 使用绿色线条
% 添加标题和轴标签
title('E-M plot', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Magnetic Field', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Electric Field', 'FontSize', 12, 'FontWeight', 'bold');

% 设置图例
legend('show', 'Location', 'best', 'FontSize', 10);

% 添加网格线以便于读数
grid on;

% 设置轴和图形的字体大小
set(gca, 'FontSize', 12, 'FontWeight', 'bold');

% 自动调整轴限制以更好地展示数据
axis tight;
