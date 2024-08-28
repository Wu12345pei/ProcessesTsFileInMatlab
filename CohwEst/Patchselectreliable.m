    % 找到点群中心
centre_point = [mean(log(reliable_data(reliable_data(:,5)>0.8,6))) mean(reliable_data(reliable_data(:,5)>0.8,7))];
% 找到中心以下的点
points_below_centre = reliable_data(log(reliable_data(:,6))<centre_point(1),:);
points_below_centre(:,6) = log(points_below_centre(:,6));
% 对称，计算新的分布
mirrored_points = [-points_below_centre(:,6)+2*centre_point(1) points_below_centre(:,7)];
mirrored_points_all = cat(1,mirrored_points,points_below_centre(:,6:7));
TF = Weighterout(mirrored_points_all(:,2),mirrored_points_all(:,1).^0);
mirrored_points_all = mirrored_points_all(TF==0,:);

y = log(reliable_data(:,6));
x = reliable_data(:,7);

y1 = mirrored_points_all(:,1);
x1 = mirrored_points_all(:,2);
[xi, yi] = meshgrid(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100));
[f1, ~, ~] = ksdensity([x1 y1], [xi(:) yi(:)]);
f1 = reshape(f1, size(xi,1),[]);

cutoff = 0.8;
f_plot = f1;
sorted_f = sort(f_plot(:), 'descend');
cumulative_f = cumsum(sorted_f) / sum(sorted_f);
cutoff_idx = find(cumulative_f >= cutoff, 1, 'first');
cutoff_value = sorted_f(cutoff_idx);

density_of_reliable_data = interp2(xi, yi, f1, x, y, 'linear');
reliable_data = reliable_data(density_of_reliable_data>cutoff_value,:);
    