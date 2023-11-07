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