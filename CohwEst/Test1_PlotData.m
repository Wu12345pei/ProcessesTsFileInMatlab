clear;
clc;
run("AddPath.m")

station_id = 148;
pick_storm = 1;
nonstorm_index = 1;
coh_threshold = 0.7;
period_index = 10;

[Data_hxey,Data_hyex] = GatherData(station_id,pick_storm,period_index,coh_threshold);

norm_hx = sqrt(Data_hxey(:,1).^2 + Data_hxey(:,2).^2);
norm_hy = sqrt(Data_hyex(:,1).^2 + Data_hyex(:,2).^2);
norm_ey = sqrt(Data_hxey(:,3).^2 + Data_hxey(:,4).^2);
norm_ex = sqrt(Data_hyex(:,3).^2 + Data_hyex(:,4).^2);

[z_xy,eps_xy] = OLS(Data_hxey);
[z_yx,eps_yx] = OLS(Data_hyex);
[z_xy_i,eps_xy_i] = IRLS_Mest(Data_hxey);
[z_yx_i,eps_yx_i] = IRLS_Mest(Data_hyex);

figure(1)
tiledlayout(2,1)
ax1 = nexttile;
scatter(norm_hx,norm_ey,[],Data_hxey(:,5),"filled");
b=colorbar();
ylabel(b,'Wavelet Coherence')
xlabel('Hx in frequency domain')
ylabel('Ey in frequency domain')
hold on;
refline(norm(z_xy))
refline(norm(z_xy_i))
ax2 = nexttile;
scatter(norm_hy,norm_ex,[],Data_hyex(:,5),"filled");
b=colorbar();
ylabel(b,'Wavelet Coherence')
xlabel('Hy in frequency domain')
ylabel('Ex in frequency domain')
hold on;
refline(norm(z_yx))
refline(norm(z_yx_i))