clear;
clc;
run("AddPath.m")

station_id = 130;
start = 2;
endd = 15;
index_list = start:endd;
real_zxy_storm = start:endd;
imag_zxy_storm = real_zxy_storm;
real_zxy_reliable = real_zxy_storm;
imag_zxy_reliable = real_zxy_storm;

for period_index = start:endd
    pick_storm = 1;
    coh_threshold = 0.5;
    [Data_hxey,Data_hyex] = GatherData(station_id,pick_storm,period_index,coh_threshold);
    [z_xy_i,eps_xy_i] = IRLS_Mest(Data_hxey);
    
    pick_storm = 0;
    coh_threshold = 0.5;
    
    [Data_hxey,Data_hyex] =  GatherData(station_id,pick_storm,period_index,coh_threshold);
    [reliable_data,ureliable_data,unknown_data] = Distinguish2Region(Data_hxey);
    [z_xy_r,eps_xy_r] = IRLS_Mest(reliable_data);

    real_zxy_storm(period_index - 1) = z_xy_i(1);
    imag_zxy_storm(period_index - 1) = z_xy_i(2);
    real_zxy_reliable(period_index - 1) = z_xy_r(1);
    imag_zxy_reliable(period_index - 1) = z_xy_r(2);
end

figure(1)
tiledlayout(2,1)
ax1 = nexttile;
plot(index_list,real_zxy_storm)
hold on;
plot(index_list,real_zxy_reliable)
ax1 = nexttile;
plot(index_list,imag_zxy_storm)
hold on;
plot(index_list,imag_zxy_reliable)
