 function [data_selected] = SelectdatabyDistribution(xi,yi,f,data,cutoff)
%SELECTDATABYDISTRIBUTION 此处显示有关此函数的摘要
%   此处显示详细说明
x = data(:,1);
y = data(:,2);
density_of_reliable_data = interp2(xi, yi, f, x, y, 'linear');
x_selected = y(density_of_reliable_data>cutoff);
y_selected = y(density_of_reliable_data>cutoff);
data_selected = [x_selected y_selected];
end

