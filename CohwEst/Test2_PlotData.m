clear;
clc;
run("AddPath.m")

%% 输入想要得到的信息
%% 台站编号，是否为磁暴期间，筛选的小波相干值，周期数
station_id = 148;                                                                                                                                                                                                                                                                                                               ;
pick_storm = 0;
coh_threshold = 0.75;
period_index = 10;

%% 读取数据，以及每个点对应的时间
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = ReadSignal(station_id);
if pick_storm == 0
    sig = zeros(0,5);
    Time_list = zeros(0,1);
    for i = 1:length(NonstormEMsignals)
        sig = cat(1,sig,NonstormEMsignals{i});
        Time_sig_i = Nonstormtimes(i,:);                       
        Time_sig = Nonstormtimes;
        Time_list_i = WrapSignaltime(NonstormEMsignals{i},Time_sig_i);
        Time_list = cat(1,Time_list,Time_list_i);
    end
else
    sig = StormEMsignal;
    Time_sig = Stormtime;
    Time_list = WrapSignaltime(sig,Time_sig);
end

%% 是否需要截取信号
scale =  1;
sig = sig(1:end/scale,:);
Time_list = Time_list(1:end/scale);


%% 小波分析
[wcoh,wcs,period_for_coherence,coi] = WaveletCoherence(sig, 'Hx', 'Ey');
[wcoh2,wcs2,~,coi2] = WaveletCoherence(sig, 'Hy', 'Ey');
[cfsHx, periods_for_wavelet] = WaveletTransformer(sig, 'Hx');
[cfsEy, ~] = WaveletTransformer(sig, 'Ey');
[cfsHy, ~] = WaveletTransformer(sig, 'Hy');
[cfsEx, ~] = WaveletTransformer(sig, 'Ex');

%% 傅里叶变换，得到频域；截取Timelist内的数据
[Data_hxey,Data_hyex,p,stft_t_gap] = GatherData(station_id,pick_storm,period_index,coh_threshold);
X = Data_hxey(Data_hxey(:,8)<max(Time_list) & Data_hxey(:,8)>min(Time_list),:);
data_all = X;

[~,p_coherence_row] = min(abs(seconds(period_for_coherence)-p(period_index)));
coherence_this_period = wcoh(p_coherence_row,:);
coherence_window_L = stft_t_gap/5;

%% 计算HatMatrix
[H,lever_value_real,lever_value_imag] = CalculateHatmatrix(data_all);

%% 使用小波结果计算极化
[~,period_row] = min(abs(seconds(periods_for_wavelet) - p(period_index)));
Hx = cfsHx(period_row,:); 
Hy = cfsHy(period_row,:);
Ex = cfsEx(period_row,:);
Ey = cfsEy(period_row,:); 
[PD_E,PD_H] = CalculatePolarization(Hx,Hy,Ex,Ey,data_all(:,8),Time_sig);

%% 小波谱相除后pca
cfs_EdividebyH = abs(cfsEy./cfsHx);
cfs_EdividebyH_modi = cfs_EdividebyH(seconds(periods_for_wavelet)>50 & seconds(periods_for_wavelet)<2000, :);
for i = 1:size(cfs_EdividebyH_modi,1)
    cfs_EdividebyH_modi(i,:) = convolutionFunc(cfs_EdividebyH_modi(i,:),ones(1,round(p(period_index)/5))) ;
end


[coeff,~,~,~,explained,~] = pca(cfs_EdividebyH_modi',"NumComponents",5);
X_decomposed = cfs_EdividebyH_modi' * coeff;
figure;
tiledlayout(3,2)
for i = 1:5
    ax1 = nexttile;
    plot(coeff(:,i))
end

if pick_storm == 0
    %% 根据离群值检测判断数据是否可靠（老方法）
    [reliable_data,ureliable_data,unknown_data] = Distinguish2Region(Data_hxey);
    reliable_data_to_plot = reliable_data(reliable_data(:,8)<max(Time_list) & reliable_data(:,8)>min(Time_list),:);
    unreliable_data_to_plot = ureliable_data;
    unreliable_data_to_plot = cat(1,ureliable_data,unknown_data);
    unreliable_data_to_plot = unreliable_data_to_plot(unreliable_data_to_plot(:,8)<max(Time_list) & unreliable_data_to_plot(:,8)>min(Time_list),:);
    
    
    %% 将分类的可靠和存疑数据分别储存
    relia = cat(2,reliable_data_to_plot,ones(size(reliable_data_to_plot,1),1));
    unrelia = cat(2,unreliable_data_to_plot,zeros(size(unreliable_data_to_plot,1),1));
    data_all = cat(1,relia,unrelia);
    data_all = sortrows(data_all,8);
    data_all_score = convolutionFunc(data_all(:,9),ones(9,1)/9);
    [~,period_row] = min(abs(seconds(periods_for_wavelet) - p(period_index)));

    Hx = cfsHx(period_row,:); 
    Hy = cfsHy(period_row,:);
    Ex = cfsEx(period_row,:);
    Ey = cfsEy(period_row,:); 
    [PD_E,PD_H] = CalculatePolarization(Hx,Hy,Ex,Ey,data_all(:,8),Time_sig);
    
    [H,lever_value_real,lever_value_imag] = CalculateHatmatrix(data_all);
    
    figure;
    ax1 = nexttile;
    scatter(Normvector(unreliable_data_to_plot,1,2),Normvector(unreliable_data_to_plot,3,4),'k.');
    hold on;
    scatter(Normvector(reliable_data_to_plot,1,2),Normvector(reliable_data_to_plot,3,4),'red.');

    figure;
    tiledlayout(2,1)
    ax1 = nexttile;
    scatter(data_all(:,8),PD_E,'k.');
    hold on;
    scatter(data_all(:,8),PD_H,'red.');
    
    
    ax2 = nexttile;
    scatter(reliable_data_to_plot(:,8),log(reliable_data_to_plot(:,6)),'r','filled')
    hold on;
    scatter(unreliable_data_to_plot(:,8),log(unreliable_data_to_plot(:,6)),'k','filled')
    xlim([min(Time_list) max(Time_list)])
    
    linkaxes([ax1,ax2],'x')
    % 
    % figure;
    % tiledlayout(2,2)
    % ax1 = nexttile;
    % WaveletTimeFreqPlotter(Time_list,period_for_coherence,50,2000,wcoh,'Hx-Ey',1)
    % 
    % ax2 = nexttile; 
    % WaveletTimeFreqPlotter(Time_list,periods_for_wavelet,50,2000,cfsHx,'Hx')
    % 
    % ax3 = nexttile;
    % WaveletTimeFreqPlotter(Time_list,periods_for_wavelet,50,2000,cfsEy,'Ey')
    % 
    % ax4 = nexttile;
    % WaveletTimeFreqPlotter(Time_list,periods_for_wavelet,50,2000,cfsEy./cfsHx,'Ey/Hx')
    % 
    % linkaxes([ax1,ax2,ax3,ax4],'x')
    xlim([2.9*10^6 3.4*10^6]);
end

if pick_storm == 1
    figure;
    tiledlayout(3,2)
    ax1 = nexttile;
    scatter(data_all(:,8),PD_E,'k.');
    hold on;
    scatter(data_all(:,8),PD_H,'red.');
    
    
    ax2 = nexttile;
    WaveletTimeFreqPlotter(Time_list,period_for_coherence,50,2000,wcoh,'HxEy',1)
    
    ax3 = nexttile;
    plot(data_all(:,8),lever_value_real);
    yline(1);
    
    
    ax4 = nexttile;
    scatter(data_all(:,8),log(data_all(:,6)),'k','filled')
    xlim([min(Time_list) max(Time_list)])
    
    ax5 = nexttile;
     WaveletTimeFreqPlotter(Time_list,periods_for_wavelet,50,2000,cfsHx,'Hx')

    ax6 = nexttile;
     WaveletTimeFreqPlotter(Time_list,periods_for_wavelet,50,2000,cfsEy,'Ey')

    linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'x')

    figure;
    tiledlayout(2,2)
    ax1 = nexttile;
    WaveletTimeFreqPlotter(Time_list,period_for_coherence,50,2000,wcoh,'HxEy',1)

    ax2 = nexttile; 
    WaveletTimeFreqPlotter(Time_list,periods_for_wavelet,50,2000,cfsHx,'Hx')
    
    ax3 = nexttile;
    WaveletTimeFreqPlotter(Time_list,periods_for_wavelet,50,2000,cfsEy,'Ey')

    ax4 = nexttile;
    WaveletTimeFreqPlotter(Time_list,periods_for_wavelet,50,2000,cfsEy./cfsHx,'Ey')

    linkaxes([ax1,ax2,ax3,ax4],'x')
end
%% 利用连续小波变换的数据，使用PCA降维，并添加时间标记
% [X_,coeff,explained,coeff_row,coeff_column] = PCAFunction(cfsHx,cfsEy,p(period_index),data_all(:,8),seconds(periods_for_wavelet),Time_sig(1));
% X_decomposed = X_*coeff(:,explained>1);
% X_decomposed = cat(2,X_decomposed,data_all(:,8));
% 
% [X_decomposed_rmout,TFrm]= rmoutliers(X_decomposed(:,1:end-1),'percentiles',[1 99]);
% X_decomposed_rmout = cat(2,X_decomposed_rmout,data_all(TFrm==0,8));
% 
% coeff_E = coeff(1:end/2,:);
% coeff_H = coeff(end/2+1:end,:);
% 
% 
% idx = kmeans(X_decomposed_rmout(:,1:end-1),2); 

%% 找到对应的Timeposition
Timeposition = findposition(data_all(:,8),Time_sig);

figure;
tiledlayout(5,5)
for i = 1:5
    for j = 1:5
        ax1 = nexttile;
        P = X_decomposed(Timeposition,:);
        scatter(P(:,i),P(:,j),'k.');
    end
end

figure;
tiledlayout(5,1)
for i = 1:5
    ax1 = nexttile;
    scatter(Time_list,X_decomposed(:,i),'k.');
end

%% 计算波动度（方差），尺度为10倍周期
Volatility = zeros(length(X_decomposed),5);
for i = 1:5
    Volatility(:,i) = CalculateVolatility(X_decomposed(:,i),round(p(period_index))*2);
end

figure;
tiledlayout(5,1)
ax1 = nexttile;
scatter(Time_list,X_decomposed(:,1),[],Volatility(:,1),'.');
colorbar;

ax2 = nexttile;
scatter(Time_list,X_decomposed(:,2),[],Volatility(:,2),'.');
colorbar;

ax3 = nexttile;
scatter(Time_list,X_decomposed(:,3),[],Volatility(:,3),'.');
colorbar;

ax4 = nexttile;
scatter(Time_list,X_decomposed(:,4),[],Volatility(:,4),'.');
colorbar;

ax5 = nexttile;
scatter(Time_list,X_decomposed(:,5),[],Volatility(:,5),'.');
colorbar;

linkaxes([ax1 ax2 ax3 ax4 ax5],'x')


%% 计算变异度CV
CV_thresthhold = 0.3;
CV = Volatility(:,1)./X_decomposed(:,1);
run('Plotselect.m')



timepoint_index_selected = find(select_list_plus==3);

run('Plot_select_timepoint.m')

index_to_abandon = timepoint_index_selected(X_decomposed(select_list_plus==3,1)>3000);
select_list_plus(index_to_abandon) = 0;
time_point_if_selected = zeros(1,length(data_all));
for i = 1:length(time_point_if_selected)
    index_time = find(Time_list==data_all(i,8));
    time_point_if_selected(i) = select_list_plus(index_time)-1;
end

%% 在选取的时段内进行傅里叶变换，并计算阻抗
%% 确定不同可以用于计算的时段
Time_choosen = Time_list(select_list_plus ==3);
Time_choosen_extension = [];
%% 扩充Time_choosen至相邻半个周期
for Time_index = 1:length(Time_choosen)
    Time_i = Time_choosen(Time_index);
    half_window_dot = round(p(period_index)/10);
    Time_i_list = (-half_window_dot:half_window_dot)*5+Time_i;
    Time_choosen_extension = cat(2,Time_choosen_extension,Time_i_list);
end
Time_choosen_extension = unique(Time_choosen_extension);
%% 定位至邻近时段的对应频点
[Data_hxey_all,Data_hyex_all,p,stft_t_gap] = GatherData(station_id,pick_storm,period_index,0);
[Data_hxey_storm,Data_hyex_storm,~,~] = GatherData(station_id,1,period_index,coh_threshold);
ok_time_indices = find(ismember(Data_hxey_all(:,8), Time_choosen_extension));
ok_data = Data_hxey_all(ok_time_indices,:);
%% 计算
[z_ok,~,~,z_ok_err,~] = IRLS_Mest(ok_data);
[z_all,~,~,z_all_err,~] = IRLS_Mest(Data_hxey_all);
[z_coh,~,~,zcoh_err,~] = IRLS_Mest(Data_hxey);
[z_storm,~,~,z_storm_err,~] = IRLS_Mest(Data_hxey_storm);
%% 鲁棒计算阻抗
run('PlotEHinokdata')