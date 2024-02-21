function [y, z, origin] = GridGenerator(Periods, Max_distance)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
max_T = max(Periods);
min_T = min(Periods);
mu = 4*pi*10^(-7);
omega_min = 2*pi*1/max_T;
omega_max = 2*pi*1/min_T;
rho_min = 1;
rho_max = 1000;
skin_depth_min = sqrt(2*rho_min/(omega_max*mu));
skin_depth_avg = sqrt(2*100/(1000*mu));
skin_depth_max = sqrt(2*rho_max/(omega_min*mu));
skin_depth = [skin_depth_min skin_depth_max];

zmax = skin_depth_max;
zmin = skin_depth_min;
z = logspace(log10(zmin), log10(zmax), 20);

y_side_distance_min = 60*1000;
y_side_distance_max = 600*1000;
y_left = logspace(log10(y_side_distance_min), log10(y_side_distance_max), 10);
y_left = fliplr(y_left);
y_center = zeros(1,60) + Max_distance/60;
y_right = logspace(log10(y_side_distance_min), log10(y_side_distance_max), 10);
y = [y_left, y_center, y_right]; 
 
origin = sum(y_left);
end

