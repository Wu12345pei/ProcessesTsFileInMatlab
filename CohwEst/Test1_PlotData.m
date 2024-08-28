clear;
clc;
run("AddPath.m")

station_id = 148;                                                                                                                                                                                                                                                                                                               ;
pick_storm = 0;
coh_threshold = 0.5;
period_index = 10;

[Data_hxey,Data_hyex] = GatherData(station_id,pick_storm,period_index,coh_threshold);


[z_xy_i,eps_xy_r,eps_xy_i,z_xy_err] = IRLS_Mest(Data_hxey);
[z_yx_i,eps_yx_r,eps_yx_i,z_yx_err] = IRLS_Mest(Data_hyex);


[reliable_data,ureliable_data,unknown_data] = Distinguish2Region(Data_hxey);
[z_xy_reliable,eps_xy_reliable,eps_xy_reliable,z_xy_err_reliable] = IRLS_Mest(reliable_data);

data_before_selected = Data_hxey;
pick_storm = 1;
coh_threshold = 0.5;
[Data_hxey_s,Data_hyex_s] = GatherData(station_id,pick_storm,period_index,coh_threshold);
data_goodtime = Data_hxey_s;

y = log(data_goodtime(:,6));
x = data_goodtime(:,7);
[xi, yi] = meshgrid(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100));
f = CalculateDistribution(xi,yi,x,y);

y0 = log(data_before_selected(:,6));
x0 = data_before_selected(:,7);
f0 = CalculateDistribution(xi,yi,x0,y0);

y2 = log(reliable_data(:,6));
x2 = reliable_data(:,7);
f2 = CalculateDistribution(xi,yi,x2,y2);

% 找到点群中心
centre_point = [mean(y2(reliable_data(:,5)>0.8)) mean(x2(reliable_data(:,5)>0.8))];
% 找到中心以下的点
points_below_centre = reliable_data(y2<centre_point(1),:);
points_below_centre(:,6) = log(points_below_centre(:,6));
% 对称，计算新的分布
mirrored_points = [-points_below_centre(:,6)+2*centre_point(1) points_below_centre(:,7)];
mirrored_points_all = cat(1,mirrored_points,points_below_centre(:,6:7));
TF = Weighterout(mirrored_points_all(:,2),mirrored_points_all(:,1).^0);
mirrored_points_all = mirrored_points_all(TF==0,:);

y5 = mirrored_points_all(:,1);
x5 = mirrored_points_all(:,2);
f5 = CalculateDistribution(xi,yi,x5,y5);

cutoff1 = GetCutOffValue(f,0.95);
cutoff5 = GetCutOffValue(f5,0.95);
cutoff2 = GetCutOffValue(f2,0.95);

density_of_reliable_data1 = interp2(xi, yi, f, x2, y2, 'linear');
density_of_reliable_data2 = interp2(xi, yi, f2, x2, y2, 'linear');
density_of_reliable_data5 = interp2(xi, yi, f5, x2, y2, 'linear');
density_of_all_data = interp2(xi, yi, f0, x0, y0, 'linear');

reliable_selected5 = reliable_data(density_of_reliable_data5>cutoff5,:);
x2_selected5 = x2(density_of_reliable_data5>cutoff5);
y2_selected5 = y2(density_of_reliable_data5>cutoff5);

reliable_selected2 = reliable_data(density_of_reliable_data2>cutoff2,:);
x2_selected2 = x2(density_of_reliable_data2>cutoff2);
y2_selected2 = y2(density_of_reliable_data2>cutoff2);

reliable_selected1 = reliable_data(density_of_reliable_data1>cutoff1,:);

x2_selected1 = x2(density_of_reliable_data1>cutoff1);
y2_selected1 = y2(density_of_reliable_data1>cutoff1);

all_selected1 = data_before_selected(density_of_all_data>cutoff1,:);

x0_selected1 = x0(density_of_all_data>cutoff1);
y0_selected1 = y0(density_of_all_data>cutoff1);

y6 = y2_selected5;
x6 = x2_selected5;
f6 = CalculateDistribution(xi,yi,x6,y6);

y7 = y2_selected1;
x7 = x2_selected1;
f7 = CalculateDistribution(xi,yi,x7,y7);

%计算杠杆值原数据，第一次筛选后数据，第二次筛选后数据
[H_storm,lreal_s,limag_s] = CalculateHatmatrix(Data_hxey_s);
[H_reliable,lreal_re,limag_re] = CalculateHatmatrix(reliable_data);
[H_reliable_selected,lreal_res,limag_res] = CalculateHatmatrix(reliable_selected5);

[z_xy_non_i,eps_xy_non_r,eps_xy_non_i,z_xy_non_err,weight_nons] = IRLS_Mest(data_before_selected);
[z_xy_non_l,eps_xy_non_l,eps_xy_non_l] = OLS(data_before_selected);
[z_xy_i,eps_xy_r,eps_xy_i,z_xy_err,weight_s] = IRLS_Mest(Data_hxey_s);
[z_xy_reliable,eps_xy_reliable,eps_xy_reliable,z_xy_err_reliable,weight_reliable] = IRLS_Mest(reliable_data);
[z_xy_reliables,eps_xy_reliables,eps_xy_reliables,z_xy_err_reliables,weight_reliables] = IRLS_Mest(reliable_selected1);
[z_xy_all_s,~,~,~,weight_all_s] = IRLS_Mest(all_selected1);
figure;
tiledlayout(2,1)
ax1 = nexttile;
scatter(Data_hxey(:,7),log(Data_hxey(:,6)),[],Data_hxey(:,5),"filled");
yline(log(norm(z_xy_non_i)),'red');
yline(log(norm(z_xy_reliables)),'blue');
hold on;
scatter(x2,y2,'black',"filled");
hold on;
scatter(x2(reliable_data(:,5)>0.8),y2(reliable_data(:,5)>0.8),'red',"filled");
% hold on;
% scatter(reliable_data(reliable_data(:,5)>0.8,7),log(reliable_data(reliable_data(:,5)>0.8,6)),'red',"filled");

b=colorbar();
ylabel(b,'Wavelet Coherence')
xlabel('zxy in theta')
ylabel('zxy in rho')
ax1 = nexttile;
scatter(Data_hyex(:,7),log(Data_hyex(:,6)),[],Data_hyex(:,5),"filled");
b=colorbar();
ylabel(b,'Wavelet Coherence')
xlabel('zyx in real') 
ylabel('zyx in imag')

figure;
% 良好时期的散点密度分布
tiledlayout(2,2)
ax1 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f);
axis xy; 
colorbar; 
hold on;
scatter(data_goodtime(:,7),log(data_goodtime(:,6)),'black',"filled");

ax1 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f2);
axis xy; 
colorbar; 
hold on;
scatter(x2,y2,'black',"filled");
hold on;
scatter(x2(reliable_data(:,5)>0.8),y2(reliable_data(:,5)>0.8),'m',"filled");
hold on;
sz = 200;
scatter(mean(x2(reliable_data(:,5)>0.8)),mean(y2(reliable_data(:,5)>0.8)),sz,'red','pentagram','filled');
hold on;
scatter(mean(x2),mean(y2),sz,'k','pentagram','filled');

ax1 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f);
axis xy; 
colorbar; 
hold on;
scatter(x0,y0,'blue',"filled");
hold on;
scatter(x2,y2,'black',"filled");
hold on;
scatter(x2(reliable_data(:,5)>0.8),y2(reliable_data(:,5)>0.8),'m',"filled");
hold on;
sz = 200;
scatter(mean(x2(reliable_data(:,5)>0.8)),mean(y2(reliable_data(:,5)>0.8)),sz,'red','pentagram','filled');
hold on
scatter(mean(x2),mean(y2),sz,'k','pentagram','filled');

ax1 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f2);
axis xy; 
colorbar; 
hold on;
scatter(x,y,'black',"filled");

figure;
tiledlayout(1,3)
ax1 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f);
axis xy; 
colorbar; 
hold on;
scatter(x,y,'black',"filled");
ax1 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f5);
axis xy; 
colorbar; 
hold on;
scatter(x2,y2,'black',"filled")
ax1 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f2);
axis xy; 
colorbar; 
hold on;
scatter(x2,y2,'black',"filled")

figure;
tiledlayout(1,3)
ax1 = nexttile;
cutoff1 = Plotcontour(xi,yi,f,0.95);
scatter(x2, y2, 'k.');
hold on;
scatter(x2_selected1, y2_selected1, 'r.');
legend('Data Points', '95% Probability Region');
hold off;
ax1 = nexttile;
cutoff5 = Plotcontour(xi,yi,f5,0.8);
scatter(x2, y2, 'k.');
hold on;
scatter(x2_selected5, y2_selected5, 'r.');
legend('Data Points', '80% Probability Region');
hold off;
ax1 = nexttile;
cutoff2 = Plotcontour(xi,yi,f2,0.8);
scatter(x2, y2, 'k.');
hold on;
scatter(x2_selected2, y2_selected2, 'r.');
legend('Data Points', '80% Probability Region');
hold off;

figure;
tiledlayout(2,2)
ax0 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f);
hold on;
scatter(x, y,'k.');
xlabel('zxy in theta')
ylabel('zxy in rho')
axis xy; 
colorbar; 

ax1 = nexttile;
imagesc(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100), f7);
hold on;
scatter(x2_selected1, y2_selected1, 'k.');
xlabel('zxy in theta')
ylabel('zxy in rho')
axis xy; 
colorbar; 

ax2 = nexttile;
boxchart(ax2, y, 'orientation', 'vertical','Notch','on');
yline(log(norm(z_xy_i)))

ax3 = nexttile;
boxchart(ax3, y7, 'orientation', 'vertical','Notch','on');
yline(log(norm(z_xy_reliable)))
linkaxes([ax2,ax3],'y');
linkaxes([ax0,ax1],'xy');

figure;
tiledlayout(1,3)
ax1 = nexttile;
scatter(x, y,[],lreal_s,'filled');
axis xy; 
colorbar; 

ax2 = nexttile;
scatter(x6, y6,[],lreal_res,'filled');
axis xy; 
colorbar; 

ax3 = nexttile;
scatter(x2, y2,[],lreal_re, 'filled');
axis xy; 
colorbar; 
linkaxes([ax1,ax2,ax3],'xy');

figure;
tiledlayout(2,3)
ax1 = nexttile;
scatter(x, y,[],weight_s(1:2:end),'filled');
axis xy; 
colorbar; 

ax2 = nexttile;
scatter(x0, y0,[],weight_nons(1:2:end),'filled');
axis xy; 
colorbar; 

ax3 = nexttile;
scatter(x2, y2,[],weight_reliable(1:2:end), 'filled');
axis xy; 
colorbar; 
linkaxes([ax1,ax2,ax3],'xy');

ax4 = nexttile;
scatter(x, y,[],weight_s(2:2:end),'filled');
axis xy; 
colorbar; 

ax5 = nexttile;
scatter(x0, y0,[],weight_nons(2:2:end),'filled');
axis xy; 
colorbar; 

ax6 = nexttile;
scatter(x2, y2,[],weight_reliable(2:2:end), 'filled');
axis xy; 
colorbar; 
linkaxes([ax4,ax5,ax6],'xy');