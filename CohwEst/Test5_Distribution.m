clear;
clc;
run("AddPath.m")

station_id = 133;
pick_storm = 1;
nonstorm_index = 1;
coh_threshold = 0;
period_index = 10;

[Data_hxey,Data_hyex] = GatherData(station_id,pick_storm,period_index,coh_threshold);

norm_hx = sqrt(Data_hxey(:,1).^2 + Data_hxey(:,2).^2);
norm_hy = sqrt(Data_hyex(:,1).^2 + Data_hyex(:,2).^2);
norm_ey = sqrt(Data_hxey(:,3).^2 + Data_hxey(:,4).^2);
norm_ex = sqrt(Data_hyex(:,3).^2 + Data_hyex(:,4).^2);

[z_xy,eps_real_xy,eps_imag_xy] = IRLS_Mest(Data_hxey);
[z_yx,eps_real_yx,eps_imag_yx] = IRLS_Mest(Data_hyex);

eps_real_xy = normalize(eps_real_xy);
eps_imag_xy = normalize(eps_imag_xy);
eps_real_yx = normalize(eps_real_yx);
eps_imag_yx = normalize(eps_imag_yx);

[h_imag_xy,p_imag_xy] = kstest(eps_imag_xy);
[h_imag_yx,p_imag_yx] = kstest(eps_imag_yx);
[h_real_xy,p_real_xy] = kstest(eps_real_xy);
[h_real_yx,p_real_yx] = kstest(eps_real_yx);

x = -10:0.1:10;
pd_real_xy = fitdist(eps_real_xy,'Stable');
pd_imag_xy = fitdist(eps_imag_xy,'Stable');
pd_real_yx = fitdist(eps_real_yx,'Stable');
pd_imag_yx = fitdist(eps_imag_yx,'Stable');

cd_rxy = [x',cdf(pd_real_xy,x)'];
cd_ryx = [x',cdf(pd_real_yx,x)'];
cd_ixy = [x',cdf(pd_imag_xy,x)'];
cd_iyx = [x',cdf(pd_imag_yx,x)'];

[h_real_xy_stable,p_real_xy_stable] = kstest(eps_real_xy,'CDF',cd_rxy);
[h_real_yx_stable,p_real_yx_stable] = kstest(eps_real_yx,'CDF',cd_ryx);
[h_imag_xy_stable,p_imag_xy_stable] = kstest(eps_imag_xy,'CDF',cd_ixy);
[h_imag_yx_stable,p_imag_yx_stable] = kstest(eps_imag_yx,'CDF',cd_iyx);

[p_real_xy_stable,p_real_yx_stable,p_imag_xy_stable,p_imag_yx_stable]
[p_real_xy,p_real_yx,p_imag_xy,p_imag_yx]