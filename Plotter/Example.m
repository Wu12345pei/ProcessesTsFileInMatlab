%% 原始信号
RawDataPlotter(time, EMsignal, ['Hx'], 1);

%% 傅里叶变换
[EMsignalFreq, freq] = FFTransformer(EMsignal);
plot(freq, EMsignalFreq);
xlabel('Frequency');
ylabel('EMsignalPower');

%% 小波变换
[cfs, periods] = WaveletTransformer(EMsignal, 'Hx');
WaveletTimeFreqPlotter(Time, periods, cfs, channel, lim)

%% 小波相关

%% 阻抗大小

%% 阻抗幅角

%% 视电阻率大小

%% 视电阻率幅角

%% 某时间段互相关性

%% 某时间段小波相关

%% 分段傅里叶变换散点图