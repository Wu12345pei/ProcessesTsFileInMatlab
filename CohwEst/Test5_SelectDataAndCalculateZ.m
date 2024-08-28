clear;
clc;
run("AddPath.m")
load("p.mat")

%% 台站编号，为非磁暴期间，筛选的小波相干值，周期数
station_id = 136;                                                                                                                                                                                                                                                                                                               ;
pick_storm = 0;
coh_threshold = 0.75;


%% 读取非磁暴数据，以及每个点对应的时间
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = ReadSignal(station_id);

sig = zeros(0,5);
Time_list = zeros(0,1);
for i = 1:length(NonstormEMsignals)
    sig = cat(1,sig,NonstormEMsignals{i});
    Time_sig_i = Nonstormtimes(i,:);                       
    Time_sig = Nonstormtimes;
    Time_list_i = WrapSignaltime(NonstormEMsignals{i},Time_sig_i);
    Time_list = cat(1,Time_list,Time_list_i);
end



%% 小波分析
[wcoh,wcs,period_for_coherence,coi] = WaveletCoherence(sig, 'Hx', 'Ey');
[wcoh2,wcs2,~,coi2] = WaveletCoherence(sig, 'Hy', 'Ey');
[cfsHx, periods_for_wavelet] = WaveletTransformer(sig, 'Hx');
[cfsEy, ~] = WaveletTransformer(sig, 'Ey');
[cfsHy, ~] = WaveletTransformer(sig, 'Hy');
[cfsEx, ~] = WaveletTransformer(sig, 'Ex');


% [~,p_coherence_row] = min(abs(seconds(period_for_coherence)-p(period_index)));
coherence_this_period = wcoh(seconds(periods_for_wavelet)>200 & seconds(periods_for_wavelet)<2000,:);
coherence_this_period = mean(coherence_this_period,1);
coherence_window_L = 256;

%% 小波谱相除，选取关心的周期范围，在一个周期内平滑，pca
cfs_EdividebyH = abs(cfsEy./cfsHx);
cfs_EdividebyH_modi = cfs_EdividebyH(seconds(periods_for_wavelet)>50 & seconds(periods_for_wavelet)<2000, :);
for i = 1:size(cfs_EdividebyH_modi,1)
    cfs_EdividebyH_modi(i,:) = convolutionFunc(cfs_EdividebyH_modi(i,:),ones(1,coherence_window_L)/coherence_window_L);
end

[coeff,~,~,~,explained,~] = pca(cfs_EdividebyH_modi',"NumComponents",5);
X_decomposed = cfs_EdividebyH_modi' * coeff;

%% 计算波动度（方差），尺度为计算stft的时间gap
Volatility = zeros(length(X_decomposed),5);
for i = 1:5
    Volatility(:,i) = CalculateVolatility(X_decomposed(:,i),coherence_window_L);
end

%% 计算变异度
CV_thresthhold = 0.3;
CV = Volatility(:,1)./X_decomposed(:,1);

%% 同时使用CV和coherence筛选合适的时间点
select_list = zeros(length(Time_list),1); 
select_list(coherence_this_period>=coh_threshold) = select_list(coherence_this_period>=coh_threshold) + 1;
select_list(CV<=CV_thresthhold) = select_list(CV<=CV_thresthhold) + 1;
Volatility_timepoint = Volatility(select_list==2,1);
timepoint_index_selected = find(select_list==2);

%% 筛选后的点经过手动设置阈值进行第二次筛选
figure;
scatter(Time_list(timepoint_index_selected),X_decomposed(timepoint_index_selected,1),'filled');

index_to_abandon = timepoint_index_selected(X_decomposed(select_list==2,1)>200);
select_list(index_to_abandon) = 0;

%% 确定不同可以用于计算的时段
Time_choosen = Time_list(select_list ==2);
Time_choosen_extension = [];
%% 扩充Time_choosen至相邻半个周期
for Time_index = 1:length(Time_choosen)
    Time_i = Time_choosen(Time_index);
    half_window_dot = coherence_window_L/2;
    Time_i_list = (-half_window_dot:half_window_dot)*5+Time_i;
    Time_choosen_extension = cat(2,Time_choosen_extension,Time_i_list);
end
Time_choosen_extension = unique(Time_choosen_extension);

%% 定位至邻近时段的对应频点

% figure;
% scatter(Normvector(ok_data,1,2),Normvector(ok_data,3,4),'r.');

%% 傅里叶变换，得到频域；截取Timelist内的数据
p_begin = 2;
p_end = 10;
z_ok_list = zeros(p_end,2);
z_ok_err_list = zeros(p_end,2);
z_all_list = zeros(p_end,2);
z_all_err_list = zeros(p_end,2);
z_coh_list = zeros(p_end,2);
z_coh_err_list = zeros(p_end,2);
z_storm_list = zeros(p_end,2);
z_storm_err_list = zeros(p_end,2);
for period_index = p_begin:p_end
    [Data_hxey_all,Data_hyex_all,~,~] = GatherData(station_id,pick_storm,period_index,0);
    [Data_hxey,Data_hyex,~,stft_t_gap] = GatherData(station_id,pick_storm,period_index,coh_threshold);
    [Data_hxey_storm,Data_hyex_storm,~,~] = GatherData(station_id,1,period_index,coh_threshold);
    if period_index == p_begin
        ok_time_indices = find(ismember(Data_hxey_all(:,8), Time_choosen_extension));
    end
    ok_data = Data_hxey_all(ok_time_indices,:);

    [z_ok,~,~,z_ok_err,~] = IRLS_Mest(ok_data);
    [z_all,~,~,z_all_err,~] = IRLS_Mest(Data_hxey_all);
    [z_coh,~,~,z_coh_err,~] = IRLS_Mest(Data_hxey);
    [z_storm,~,~,z_storm_err,~] = IRLS_Mest(Data_hxey_storm);
    z_ok_list(period_index,:) = z_ok;
    z_ok_err_list(period_index,:) = z_ok_err;
    z_all_list(period_index,:) = z_all;
    z_all_err_list(period_index,:) = z_all_err;
    z_coh_list(period_index,:) = z_coh;
    z_coh_err_list(period_index,:) = z_coh_err;
    z_storm_list(period_index,:) = z_storm;
    z_storm_err_list(period_index,:) = z_storm_err;
end

angle_storm = rad2deg(angle(z_storm_list(:,1)+1i*z_storm_list(:,2)));
angle_storm_err = ((z_storm_list(:,2).^2)./((z_storm_list(:,2).^2 + z_storm_list(:,1).^2).^2)).*(z_storm_err_list(:,1).^2) + ((z_storm_list(:,1).^2)./((z_storm_list(:,2).^2 + z_storm_list(:,1).^2).^2)).*(z_storm_err_list(:,2).^2);
angle_storm_err = rad2deg(sqrt(angle_storm_err));

angle_all = rad2deg(angle(z_all_list(:,1)+1i*z_all_list(:,2)));
angle_all_err = ((z_all_list(:,2).^2)./((z_all_list(:,2).^2 + z_all_list(:,1).^2).^2)).*(z_all_err_list(:,1).^2) + ((z_all_list(:,1).^2)./((z_all_list(:,2).^2 + z_all_list(:,1).^2).^2)).*(z_all_err_list(:,2).^2);
angle_all_err = rad2deg(sqrt(angle_all_err));

angle_ok = rad2deg(angle(z_ok_list(:,1)+1i*z_ok_list(:,2)));
angle_ok_err = ((z_ok_list(:,2).^2)./((z_ok_list(:,2).^2 + z_ok_list(:,1).^2).^2)).*(z_ok_err_list(:,1).^2) + ((z_ok_list(:,1).^2)./((z_ok_list(:,2).^2 + z_ok_list(:,1).^2).^2)).*(z_ok_err_list(:,2).^2);
angle_ok_err = rad2deg(sqrt(angle_ok_err));

angle_coh = rad2deg(angle(z_coh_list(:,1)+1i*z_coh_list(:,2)));
angle_coh_err = ((z_coh_list(:,2).^2)./((z_coh_list(:,2).^2 + z_coh_list(:,1).^2).^2)).*(z_coh_err_list(:,1).^2) + ((z_coh_list(:,1).^2)./((z_coh_list(:,2).^2 + z_coh_list(:,1).^2).^2)).*(z_coh_err_list(:,2).^2);
angle_coh_err = rad2deg(sqrt(angle_coh_err));


run('plotZ.m')

run('plotEHinokdata')

