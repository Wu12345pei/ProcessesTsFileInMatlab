function [cutoff_value] = Plotcontour(xi,yi,f,cutoff)
%PLOTCONTOUR 此处显示有关此函数的摘要
%   此处显示详细说明
cutoff_value = GetCutOffValue(f,cutoff);

f_plot = f;
contourf(xi, yi, f_plot, 20); 
hold on;
[c, h] = contour(xi, yi, f_plot, [cutoff_value, cutoff_value], 'LineColor', 'r', 'LineWidth', 2);
clabel(c, h, 'FontSize', 10, 'LabelSpacing', 400);
colorbar;
title(strcat('Kernel Density Estimation with ',num2str(cutoff*100),'% CI'));
end

