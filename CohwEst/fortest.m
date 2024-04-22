clear;
clc;
run("AddPath.m")

station_id = 148;
pick_storm = 0;
nonstorm_index = 1;
coh_threshold = 0.7;
period_index = 10;

[Data_hxey,Data_hyex] = GatherData(station_id,pick_storm,period_index,coh_threshold);
[reliable_data,ureliable_data,unknown_data] = Distinguish2Region(Data_hxey);


% hold on;
% scatter(sqrt(ureliable_data(:,1).^2+ureliable_data(:,2).^2),sqrt(ureliable_data(:,3).^2+ureliable_data(:,4).^2),'blue','filled');
% hold on;
% scatter(sqrt(unknown_data(:,1).^2+unknown_data(:,2).^2),sqrt(unknown_data(:,3).^2+unknown_data(:,4).^2),'m','filled');

pick_storm = 1;
[Data_hxey_s,Data_hyex_s] = GatherData(station_id,pick_storm,period_index,coh_threshold);
[z,eps_real,eps_imag] = IRLS_Mest(Data_hxey_s);

figure(1)
scatter(sqrt(unknown_data(:,1).^2+unknown_data(:,2).^2),sqrt(unknown_data(:,3).^2+unknown_data(:,4).^2),'blue','filled');
hold on;
scatter(sqrt(reliable_data(:,1).^2+reliable_data(:,2).^2),sqrt(reliable_data(:,3).^2+reliable_data(:,4).^2),'red','filled');
hold on;
refline(norm(z));

eps_reliable_real = reliable_data(:,3) - reliable_data(:,1)*z(1) + reliable_data(:,2)*z(2);
eps_reliable_imag = reliable_data(:,4) - reliable_data(:,1)*z(2) - reliable_data(:,2)*z(1);

eps_real = normalize(eps_real);
eps_reliable_real = normalize(eps_reliable_real);

figure(2)
tiledlayout(2,1)
ax1 = nexttile;
histogram(eps_real,Normalization='percentage');
ax2 = nexttile;
histogram(eps_reliable_real,Normalization='percentage');

figure(3)
tiledlayout(2,1)
ax1 = nexttile;
qqplot(eps_real);
ax2 = nexttile; 
qqplot(eps_reliable_real);

x = -10:0.1:10;
pd_real_xy = fitdist(eps_real,'Stable');
cd_rxy = [x',cdf(pd_real_xy,x)'];
[h_real_xy_stable,p_real_xy_stable] = kstest(eps_real,'CDF',cd_rxy);
[h_reliable_real_xy_stable,p_reliable_real_xy_stable] = kstest(eps_reliable_real,'CDF',cd_rxy);