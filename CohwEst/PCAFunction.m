function [X,coeff_row,coeff_column] = PCAFunction(cfs_H,cfs_E,period,t,periods,time_start)
%PCAFUNCTION 此处显示有关此函数的摘要
%   此处显示详细说明
H_data = zeros(0);
E_data = zeros(0);
Z_data = zeros(0);
%% 确定 时域和频域的窗口长度
period_window_min = period/1.414;
period_window_max = period*1.414;
cfs_H = cfs_H(periods<period_window_max & periods>period_window_min,:);
cfs_E = cfs_E(periods<period_window_max & periods>period_window_min,:);
cfs_Z = cfs_E ./ cfs_H;



t = t - time_start;
time_window_halflength = round(t(1)/5);
coeff_column = size(cfs_H,1);
Gauss_window1 = gausswin(coeff_column);
Gauss_window2 = gausswin(2*time_window_halflength);
%% 根据timelist和period在不同的点选取数据
for i = 1:length(t)
    column_start = round(t(i)/5) - time_window_halflength +1;
    column_end = round(t(i)/5) + time_window_halflength;
%% 得到关于H的数据
    data_H = cfs_H(:,column_start:column_end);
    data_H = data_H .*(Gauss_window1*Gauss_window2');
    data_H = data_H(:)';
    H_data_for_join = cat(2,real(data_H),imag(data_H));
    H_data = cat(1,H_data,H_data_for_join);
%% 得到关于E的数据
    data_E = cfs_E(:,column_start:column_end);
    data_E = data_E .*(Gauss_window1*Gauss_window2');
    data_E = data_E(:)';
    E_data_for_join = cat(2,real(data_E),imag(data_E));
    E_data = cat(1,E_data,E_data_for_join);
%% 得到关于Z的数据
    data_Z = cfs_Z(:,column_start:column_end);
    data_Z = data_Z .*(Gauss_window1*Gauss_window2');
    data_Z = data_Z(:)';
    Z_data_for_join = cat(2,real(data_Z),imag(data_Z),abs(data_Z));
    Z_data = cat(1,Z_data,Z_data_for_join);
%% 
end

X = cat(2,E_data,H_data,Z_data);
coeff_row = length(X) / (2*coeff_column);
end

