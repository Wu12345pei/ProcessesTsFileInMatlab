<<<<<<< HEAD
fname = 'kap03/kap160as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

fname = 'kap03/kap163as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsigal_ref{1});

fname = 'kap03/kap145as.ts';
[pos_noisy, Time_noisy, EMsigal_noisy] = TsReaderFunc(fname);
[Nonstormtimes_noisy, Stormtime_noisy, NonstormEMsignals_noisy, StormEMsignal_noisy] = StormDataExtractor(Time_noisy, EMsigal_noisy);

figure(1)
[wcoh0,period,coi] = WaveletCoherence(StormEMsignal, 'Hx', 'Ey');

figure(2)
[wcoh_noisy,period,coi] = WaveletCoherence(StormEMsignal_noisy, 'Hx', 'Ey');

StormEMsignal_polluted = zeros(51841, 5);

period = seconds(period);
T = 1000;
[dis,period_row] = min(abs(period - T));
wcoh_score = wcoh_noisy(period_row, :);
propotion = (1 - wcoh_score).^1.5;
propotion = propotion';
figure(3)
subplot(2,1,1)
plot(wcoh_score);
subplot(2,1,2)
plot(propotion);

periods_for_cal = [T 10000];
freq = 1./periods_for_cal;

Signalset0 = SignalSetTransformer(Stormtime, StormEMsignal);
[Impedance0, period_cal] = ImpedanceCalculaterBIRRP(Signalset0, Signalset_ref, freq);
imp0 = double(Impedance0.impedance);
Zxy0 = abs(imp0(1, 1, 2));


for i = 1:5
StormEMsignal_polluted(:,i) = (StormEMsignal(:,i).*(1-propotion) + StormEMsignal_noisy(:,i).*propotion);
end
figure(4)
[wcoh_polluted,period,coi] = WaveletCoherence(StormEMsignal_polluted,'Hx','Ey');
wcoh_polluted_score = wcoh_polluted(period_row,:);

%方案一，不做任何处理，直接使用磁暴数据
Signalset_polluted = SignalSetTransformer(Stormtime, StormEMsignal_polluted);
[Impedance_polluted, period_cal] = ImpedanceCalculaterBIRRP(Signalset_polluted, Signalset_ref, freq);
imp_polluted = double(Impedance_polluted.impedance);
Zxy_polluted = abs(imp_polluted(1, 1, 2));

%方案二，选取不同倍数最高coh进行计算
gap = 2;
max_len = 200;
len_num = max_len/gap;
Zxy_optimized = zeros(1,len_num);
max_scores = zeros(1,len_num);
for len = gap:gap:max_len
    series_length = len * T;
    lines_length = series_length/5;
    max_score = 0;
    for start_line = 1 : 10 : round((length(wcoh_polluted_score) - lines_length)/10)*10-9
        score = mean(wcoh_polluted_score(start_line:start_line+lines_length));
        if score > max_score
            max_score = score;
            best_line = start_line;
            best_start_time = start_line*5+Stormtime(1);
        end
    end
    Timeseries_for_cal = [best_start_time best_start_time+series_length];
    data_for_cal = DataSlicer(Stormtime,{StormEMsignal_polluted},Timeseries_for_cal);
    signalset_selected = SignalSetTransformer(Timeseries_for_cal,data_for_cal);
    [Impedance_optimized, period_cal] = ImpedanceCalculaterBIRRP(signalset_selected, Signalset_ref, freq);
    imp_optimized = double(Impedance_optimized.impedance);
    Zxy_optimized(len/gap) = abs(imp_optimized(1, 1, 2));
    max_scores(len/gap) = max_score;
end
figure(5)
scatter(gap:gap:max_len, Zxy_optimized)
yline(Zxy0,Color='b')
yline(Zxy_polluted,Color='r')
xlim([0 max_len])
figure(6)
scatter(gap:gap:max_len,max_scores)
xlim([0 max_len])
=======
load('matlab.mat')
fname = 'kap03/kap160as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

fname = 'kap03/kap163as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReadero/Func(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsigal_ref{1});

fname = 'kap03/kap139as.ts';
[pos_noisy, Time_noisy, EMsigal_noisy] = TsReaderFunc(fname);
[Nonstormtimes_noisy, Stormtime_noisy, NonstormEMsignals_noisy, StormEMsignal_noisy] = StormDataExtractor(Time_noisy, EMsigal_noisy);
figure(1)
[wcoh0,period,coi] = WaveletCoherence(StormEMsignal, 'Hx', 'Ey');

%噪音台站
figure(2)
% [wcoh_noisy,period,coi] = WaveletCoherence(NonstormEMsignals_noisy{1}, 'Hx', 'Ey');
[wcoh_noisy,period,coi] = WaveletCoherence(StormEMsignal_noisy, 'Hx', 'Ey');
StormEMsignal_polluted = zeros(51841, 5);

period = seconds(period);
errandbia = zeros(10000,3);
k=1;
%对周期进行循环
T_cal = [100 150 200 250 300 350 400 450 500 550 600 650 700 750 800 850 900 950 1000];
for l = 1:length(T_cal)
    T = T_cal(l);
    % figure(3)
    % subplot(2,1,1)
    % plot(wcoh_score);
    % subplot(2,1,2)
    % plot(propotion);
    
    periods_for_cal = [T 10000];
    freq = 1./periods_for_cal;
    %正常值Zxy0计算
    Signalset0 = SignalSetTransformer(Stormtime, StormEMsignal);
    [Impedance0, period_cal] = ImpedanceCalculaterBIRRP(Signalset0, Signalset_ref, freq);
    imp0 = double(Impedance0.impedance);
    Zxy0 = abs(imp0(1, 1, 2));
    
    %添加噪声
    [dis,period_row] = min(abs(period - T));
    wcoh_score = wcoh_noisy(period_row, :);
    propotion = (1 - wcoh_score).^2;
    propotion = propotion';
    % noise = NonstormEMsignals_noisy{1};
    noise = StormEMsignal_noisy;
    for i = 1:5
    StormEMsignal_polluted(:,i) = (StormEMsignal(:,i).*(1-propotion) + noise(:,i).*propotion);
    end
    figure(4)
    [wcoh_polluted,~,coi] = WaveletCoherence(StormEMsignal_polluted,'Hx','Ey');
    wcoh_polluted_score = wcoh_polluted(period_row,:);
    
    %方案一，不做任何处理，直接使用磁暴数据
    Signalset_polluted = SignalSetTransformer(Stormtime, StormEMsignal_polluted);
    [Impedance_polluted, period_cal] = ImpedanceCalculaterBIRRP(Signalset_polluted, Signalset_ref, freq);
    imp_polluted = double(Impedance_polluted.impedance);
    err_polluted = double(Impedance_polluted.error);
    Zxy_polluted = abs(imp_polluted(1, 1, 2));
    Zxyerr_polluted = abs(err_polluted(1, 1, 2));
    
    %方案二，选取不同倍数最高coh进行计算
    gap = 5;
    % max_len = round(250000/T/gap)*gap;
    max_len = gap*round(250000/T/gap);
    len_num = max_len/gap;
    Zxy_optimized = zeros(1,len_num);
    Zxyerr_optimized = zeros(1, len_num);
    max_scores = zeros(1,len_num);
    Vq_scores = zeros(1,len_num);
    for len = gap:gap:max_len
        series_length = len * T;
        lines_length = series_length/5;
        max_score = 0;
        for start_line = 1 : 10 : round((length(wcoh_polluted_score) - lines_length)/10)*10-9
            score = mean(wcoh_polluted_score(start_line:start_line+lines_length));
            if score > max_score
                max_score = score;
                best_line = start_line;
                best_start_time = start_line*5+Stormtime(1);
            end
        end
        Timeseries_for_cal = [best_start_time best_start_time+series_length];
        data_for_cal = DataSlicer(Stormtime,{StormEMsignal_polluted},Timeseries_for_cal);
        signalset_selected = SignalSetTransformer(Timeseries_for_cal,data_for_cal);
        [Impedance_optimized, period_cal] = ImpedanceCalculaterBIRRP(signalset_selected, Signalset_ref, freq);
        imp_optimized = double(Impedance_optimized.impedance);
        err_optimized = double(Impedance_optimized.error);
        Zxy_optimized(len/gap) = abs(imp_optimized(1, 1, 2));
        Zxyerr_optimized(len/gap) = abs(err_optimized(1, 1, 2));
        max_scores(len/gap) = max_score;
        if ~isnan(abs(imp_optimized(1, 1, 2)))
            errandbia(k,1) = len;
            errandbia(k,2) = max_score;
            errandbia(k,3) = abs((abs(imp_optimized(1, 1, 2))-Zxy0))/Zxy0+abs(err_optimized(1, 1, 2))/Zxy0;
            k=k+1
        end
        % if len>=50
        %     column = round((len-50)/5)+1;
        %     row = round((max_score - 0.5)/0.01)+1;
        %     Vq_score = 1-Vq(row,column);
        %     Vq_scores(len/gap) = Vq_score;
        % else
        %     Vq_scores(len/gap) = 0;
        % end
    end
end
% figure(5)
% subplot(4,1,1)
% scatter(gap:gap:max_len,max_scores,'.');
% [m,max_index] = max(Vq_scores);
% ylabel('Average Cohwave',FontSize=20)
% title(strcat('T=',num2str(T),'s'),Fontsize=20)
% % xline(max_index*gap)
% subplot(4,1,2)
% scatter(gap:gap:max_len,Zxyerr_optimized./Zxy_optimized,'.');
% ylabel('Error/Z_0',FontSize=20)
% % xline(max_index*gap)
% subplot(4,1,3)
% scatter(gap:gap:max_len,(Zxy_optimized-Zxy0)/Zxy0,'.');
% ylabel('Bias/Z_0',FontSize=20)
% % xline(max_index*gap)
% subplot(4,1,4)
% errorbar(gap:gap:max_len,Zxy_optimized/Zxy0,Zxyerr_optimized/Zxy0)
% yline((Zxy_polluted)/Zxy0,Color='b',label='Z_noise/Z_0')
% ylabel('Z_1/Z_0',FontSize=20)
% xlabel('Length(n period)',FontSize=20)
% xline(max_index*gap,label='Best Length')
% title(strcat('T=',num2str(T),'s'),Fontsize=20)


scatter(errandbia(:,1),errandbia(:,2),[],errandbia(:,3),'filled')
clim([0 1])
colorbar
load('matlab2.mat')
[L cohw] = meshgrid(50:2:500,0.3:0.01:1);
Vq2 = griddata(errandbia(:,1),errandbia(:,2),errandbia(:,3),L,cohw);
Vq2 = fillmissing(Vq2,"linear");
load('matlab2.mat')
pcolor(50:2:500,0.3:0.01:1,Vq2)
clim([0 1])
colorbar
>>>>>>> 4b6c50e2f385fa5287298c4db6cb261a9dae6e24
