clear;
clc;
run("AddPath.m")

station_id = 130;
coh_threshold = 0.4;
p_min = 2;
p_max = 10;
z_storm = zeros(length(p_min:p_max),2);
z_nonstorm = zeros(length(p_min:p_max),2);
z_nonstorm_reliable = zeros(length(p_min:p_max),2);
z_storm_err = z_storm;
z_nonstorm_err = z_storm;
z_nonstorm_reliable_err = z_storm;

high_coh_num = zeros(length(p_min:p_max),2);


for period_index = p_min:p_max
    pick_storm = 0;
    [Data_hxey,Data_hyex,p] = GatherData(station_id,pick_storm,period_index,coh_threshold);
    [reliable_data,ureliable_data,unknown_data] = Distinguish2Region(Data_hxey);
    original_num = length(reliable_data)
    
    % run('Patchselectreliable.m')
    selected_num = length(reliable_data)
    high_coh_num(period_index - p_min + 1,1) = length(reliable_data(reliable_data(:,5)>0.8,5));
    high_coh_num(period_index - p_min + 1,2) = mean(reliable_data(:,5));
    [z3,eps_real,eps_imag,z3_err] = IRLS_Mest(Data_hxey);
    z_nonstorm(period_index - p_min + 1,:) = z3';
    z_nonstorm_err(period_index - p_min + 1,:) = z3_err';

    pick_storm = 1;
    [Data_hxey_s,Data_hyex_s] = GatherData(station_id,pick_storm,period_index,coh_threshold);
    [z1,eps_real,eps_imag,z1_err] = IRLS_Mest(Data_hxey_s);
    z_storm(period_index - p_min + 1,:) = z1';
    z_storm_err(period_index - p_min + 1,:) = z1_err';
    [z2,~,~,z2_err] = IRLS_Mest(reliable_data);



    z_nonstorm_reliable(period_index - p_min + 1,:) = z2';
    z_nonstorm_reliable_err(period_index - p_min + 1,:) = z2_err';

    eps_reliable_real = reliable_data(:,3) - reliable_data(:,1)*z2(1) + reliable_data(:,2)*z2(2);
    eps_reliable_imag = reliable_data(:,4) - reliable_data(:,1)*z2(2) - reliable_data(:,2)*z2(1);
    hold on;
end

figure(1)
tiledlayout(2,1)
ax1 = nexttile;
errorbar(p(p_min:p_max),z_storm(:,1),z_storm_err(:,1))
hold on;
errorbar(p(p_min:p_max),z_nonstorm_reliable(:,1),z_nonstorm_reliable_err(:,1))
xlabel('Period(s)','FontSize',20)
ylabel('Zxy real','FontSize',20)
legend('zxy real storm','zxy real nonstorm_reliable','Fontsize',15);

ax2 = nexttile;
errorbar(p(p_min:p_max),z_storm(:,2),z_storm_err(:,2))
hold on;
errorbar(p(p_min:p_max),z_nonstorm_reliable(:,2),z_nonstorm_reliable_err(:,2))
xlabel('Period(s)','FontSize',20)
ylabel('Zxy imag','FontSize',20)
legend('zxy imag storm','zxy imag nonstorm_reliable','Fontsize',15);

angle_storm_err = ((z_storm(:,2).^2)./((z_storm(:,2).^2 + z_storm(:,1).^2).^2)).*(z_storm_err(:,1).^2) + ((z_storm(:,1).^2)./((z_storm(:,2).^2 + z_storm(:,1).^2).^2)).*(z_storm_err(:,2).^2);
angle_storm_err = rad2deg(sqrt(angle_storm_err));
abs_storm_err = ((z_storm(:,1).^2)./(z_storm(:,2).^2 + z_storm(:,1).^2)).*(z_storm_err(:,1).^2) + ((z_storm(:,2).^2)./(z_storm(:,2).^2 + z_storm(:,1).^2)).*(z_storm_err(:,2).^2);
abs_storm_err = sqrt(abs_storm_err);

angle_nonstorm_err = ((z_nonstorm(:,2).^2)./((z_nonstorm(:,2).^2 + z_nonstorm(:,1).^2).^2)).*(z_nonstorm_err(:,1).^2) + ((z_nonstorm(:,1).^2)./((z_nonstorm(:,2).^2 + z_nonstorm(:,1).^2).^2)).*(z_nonstorm_err(:,2).^2);
angle_nonstorm_err = rad2deg(sqrt(angle_nonstorm_err));
abs_nonstorm_err = ((z_nonstorm(:,1).^2)./(z_nonstorm(:,2).^2 + z_nonstorm(:,1).^2)).*(z_nonstorm_err(:,1).^2) + ((z_nonstorm(:,2).^2)./(z_nonstorm(:,2).^2 + z_nonstorm(:,1).^2)).*(z_nonstorm_err(:,2).^2);
abs_nonstorm_err = sqrt(abs_nonstorm_err);

angle_nonstorm_reliable_err = ((z_nonstorm_reliable(:,2).^2)./((z_nonstorm_reliable(:,2).^2 + z_nonstorm_reliable(:,1).^2).^2)).*(z_nonstorm_reliable_err(:,1).^2) + ((z_nonstorm_reliable(:,1).^2)./((z_nonstorm_reliable(:,2).^2 + z_nonstorm_reliable(:,1).^2).^2)).*(z_nonstorm_reliable_err(:,2).^2);
angle_nonstorm_err = rad2deg(sqrt(angle_nonstorm_reliable_err));
abs_nonstorm_reliable_err = ((z_nonstorm_reliable(:,1).^2)./(z_nonstorm_reliable(:,2).^2 + z_nonstorm_reliable(:,1).^2)).*(z_nonstorm_reliable_err(:,1).^2) + ((z_nonstorm_reliable(:,2).^2)./(z_nonstorm_reliable(:,2).^2 + z_nonstorm_reliable(:,1).^2)).*(z_nonstorm_reliable_err(:,2).^2);
abs_nonstorm_err = sqrt(abs_nonstorm_reliable_err);

figure(2)
tiledlayout(2,1)
ax1 = nexttile;
errorbar(p(p_min:p_max),sqrt(z_storm(:,1).^2+z_storm(:,2).^2),abs_storm_err)
hold on;
errorbar(p(p_min:p_max),sqrt(z_nonstorm_reliable(:,1).^2+z_nonstorm_reliable(:,2).^2),abs_nonstorm_reliable_err)
hold on;
errorbar(p(p_min:p_max),sqrt(z_nonstorm(:,1).^2+z_nonstorm(:,2).^2),abs_nonstorm_err)
xlabel('Period(s)','FontSize',20)
ylabel('Zxy Amp','FontSize',20)
legend('zxy storm','zxy nonstorm reliable','zxy nonstorm','Fontsize',15);

ax2 = nexttile;
errorbar(p(p_min:p_max),rad2deg(atan(z_storm(:,2)./z_storm(:,1))),angle_storm_err)
hold on;
errorbar(p(p_min:p_max),rad2deg(atan(z_nonstorm_reliable(:,2)./z_nonstorm_reliable(:,1))),angle_nonstorm_reliable_err)
hold on;
errorbar(p(p_min:p_max),rad2deg(atan(z_nonstorm(:,2)./z_nonstorm(:,1))),angle_nonstorm_err )
ylim([-90 90])
xlabel('Period(s)','FontSize',20)
ylabel('Zxy angle','FontSize',20)
legend('zxy storm','zxy nonstorm reliable','zxy nonstorm','Fontsize',15);

figure(3)
angle_s = rad2deg(atan(z_storm(:,2)./z_storm(:,1)));
angle_re = rad2deg(atan(z_nonstorm_reliable(:,2)./z_nonstorm_reliable(:,1)));

scatter(p(p_min:p_max),abs((angle_s - angle_re)./angle_s) ,'blue','filled'); 
hold on;
plot(p(p_min:p_max),abs((angle_s - angle_re)./angle_s),'blue','DisplayName','Angle-err');
hold on;
scatter(p(p_min:p_max),abs(sqrt(z_nonstorm_reliable(:,1).^2+z_nonstorm_reliable(:,2).^2)-sqrt(z_storm(:,1).^2+z_storm(:,2).^2))./sqrt(z_storm(:,1).^2+z_storm(:,2).^2),'r','filled','DisplayName','Amp-err');
hold on;
plot(p(p_min:p_max),abs(sqrt(z_nonstorm_reliable(:,1).^2+z_nonstorm_reliable(:,2).^2)-sqrt(z_storm(:,1).^2+z_storm(:,2).^2))./sqrt(z_storm(:,1).^2+z_storm(:,2).^2),'r','DisplayName','Amp-err');
xlabel('Period(s)','FontSize',20)
ylabel('Err')
ylim([0 1])
legend()