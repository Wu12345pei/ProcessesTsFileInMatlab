clear;
clc;
run("AddPath.m")

station_id = 133;
pick_storm = 0;
coh_threshold = 0.5;
period_index = 9;

[Data_hxey,Data_hyex] = GatherData(station_id,pick_storm,period_index,coh_threshold);
[reliable_data,ureliable_data,unknown_data] = Distinguish2Region(Data_hxey);


% hold on;
% scatter(sqrt(ureliable_data(:,1).^2+ureliable_data(:,2).^2),sqrt(ureliable_data(:,3).^2+ureliable_data(:,4).^2),'blue','filled');
% hold on;
% scatter(sqrt(unknown_data(:,1).^2+unknown_data(:,2).^2),sqrt(unknown_data(:,3).^2+unknown_data(:,4).^2),'m','filled');

pick_storm = 1;
[Data_hxey_s,Data_hyex_s] = GatherData(station_id,pick_storm,period_index,coh_threshold);
[z1,eps_real,eps_imag] = IRLS_Mest(Data_hxey_s);
z1_norm = norm(z1);
h_norm_s = sqrt(Data_hxey_s(:,1).^2+Data_hxey_s(:,2).^2);
e_norm_s = sqrt(Data_hxey_s(:,3).^2+Data_hxey_s(:,4).^2);
norm_eps_s = e_norm_s - h_norm_s*z1_norm;
pd_norm_xy_s = fitdist(normalize(norm_eps_s),'Stable');

figure(1)
scatter(sqrt(unknown_data(:,1).^2+unknown_data(:,2).^2),sqrt(unknown_data(:,3).^2+unknown_data(:,4).^2),'m','filled');
hold on;
scatter(sqrt(reliable_data(:,1).^2+reliable_data(:,2).^2),sqrt(reliable_data(:,3).^2+reliable_data(:,4).^2),'blue','filled');
hold on;
scatter(sqrt(ureliable_data(:,1).^2+ureliable_data(:,2).^2),sqrt(ureliable_data(:,3).^2+ureliable_data(:,4).^2),'red','filled');
hold on;
refline(norm(z1));

% scatter(unknown_data(:,1),unknown_data(:,3),'m','filled');
% hold on;
% scatter(reliable_data(:,1),reliable_data(:,3),'blue','filled');
% hold on;
% scatter(ureliable_data(:,1),ureliable_data(:,3),'red','filled');
% refline(z1(1))
% 
% scatter(unknown_data(:,2),unknown_data(:,4),'m','filled');
% hold on;
% scatter(reliable_data(:,2),reliable_data(:,4),'blue','filled');
% hold on;
% scatter(ureliable_data(:,2),ureliable_data(:,4),'red','filled');
% refline(z2(1))
% refline(z1(1))
[z2,~,~] = WLS_Coherence(reliable_data);
z2_norm = norm(z2);
h_reliable = sqrt(reliable_data(:,1).^2+reliable_data(:,2).^2);
e_reliable = sqrt(reliable_data(:,3).^2+reliable_data(:,4).^2);
he_cov = cov(h_reliable,e_reliable);
he_cov = inv(he_cov);
norm_eps = normalize(e_reliable - h_reliable*z2_norm);
%%%
% modify reliable_data
[he_theta,he_rho] = cart2pol(h_reliable',e_reliable');
he_tan = tan(he_theta);

[f,xi] = ksdensity(he_tan,'Bandwidth','plug-in');
[m,I] = max(f);
[~,index_peak] = min(abs(he_tan-xi(I)));

lower_part = find(he_tan<he_tan(index_peak));
upper_part = find(he_tan>he_tan(index_peak));
h_upper = h_reliable(upper_part);
e_upper = e_reliable(upper_part);

upper_selected = zeros(1,length(lower_part));
for i = 1:length(lower_part)
    point_for_mirror = lower_part(i);
    he_tan_mirrorred = 2*he_tan(index_peak)-he_tan(i);
    h_mirrored = h_reliable(point_for_mirror);
    e_mirrored = h_mirrored * he_tan_mirrorred;
    distance_h = h_upper - h_mirrored;
    distance_e = e_upper - e_mirrored;
    [~,I] = min(he_cov(1,1)*distance_h.^2+(he_cov(1,2)+he_cov(2,1))*distance_h.*distance_e+he_cov(2,2)*distance_e.^2);
    upper_selected(i)=upper_part(I);
end
reliable_data_modi = reliable_data(cat(2,upper_selected,lower_part),:);
%%%
[z3,~,~] = WLS_Coherence(reliable_data_modi);
z3_norm = norm(z3);
hold on;
refline(z3_norm);
h_norm_modi = sqrt(reliable_data_modi(:,1).^2+reliable_data_modi(:,2).^2);
e_norm_modi = sqrt(reliable_data_modi(:,3).^2+reliable_data_modi(:,4).^2);
scatter(h_norm_modi,e_norm_modi,'filled')
hold on;
scatter(h_reliable,e_reliable)
hold on;
refline(he_tan(index_peak))
%%%
eps_reliable_real = reliable_data(:,3) - reliable_data(:,1)*z2(1) + reliable_data(:,2)*z2(2);
eps_reliable_imag = reliable_data(:,4) - reliable_data(:,1)*z2(2) - reliable_data(:,2)*z2(1);


eps_real = normalize(eps_real);
eps_reliable_real = normalize(eps_reliable_real);

eps_imag = normalize(eps_imag);
eps_reliable_imag = normalize(eps_reliable_imag);

figure(2)
tiledlayout(2,2)
ax1 = nexttile;
histogram(eps_real,Normalization='percentage');
title('eps storm real','FontSize',20);
ax2 = nexttile;
histogram(eps_reliable_real,Normalization='percentage');
title('eps nonstorm real','FontSize',20);
ax3 = nexttile;
histogram(eps_imag,Normalization='percentage');
title('eps storm imag','FontSize',20);
ax4 = nexttile;
histogram(eps_reliable_imag,Normalization='percentage');
title('eps nonstorm imag','FontSize',20);

figure(3)
tiledlayout(2,1)
ax1 = nexttile;
qqplot(eps_real);
ax2 = nexttile; 
qqplot(eps_reliable_real);

x = -10:0.1:10;
pd_real_xy = fitdist(eps_real,'Stable');
pd_imag_xy = fitdist(eps_imag,'Stable');
pd_reliable_real_xy = fitdist(eps_reliable_real,'Stable');
pd_reliable_imag_xy = fitdist(eps_reliable_imag,'Stable');
cd_rxy = [x',cdf(pd_real_xy,x)'];
cd_ixy = [x',cdf(pd_imag_xy,x)'];
[h_real_xy_stable,p_real_xy_stable] = kstest(eps_real,'CDF',cd_rxy);
[h_imag_xy_stable,p_imag_xy_stable] = kstest(eps_imag,'CDF',cd_ixy);

[h_reliable_real_xy_stable,p_reliable_real_xy_stable] = kstest(eps_reliable_real,'CDF',cd_rxy);
[h_reliable_imag_xy_stable,p_reliable_imag_xy_stable] = kstest(eps_reliable_imag,'CDF',cd_ixy);