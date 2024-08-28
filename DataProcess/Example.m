%% 对一段时间信号进行傅里叶变换
[EMsignalFreq, freq] = FFTransformer(EMsignal);

%% 对一段时间信号进行小波变换
[cfs, periods] = WaveletTransformer(EMsignal, 'Hx');

%% 对一段时间信号进行小波相关
[wcoh,periods,coi] = WaveletCoherence(EMsignal, 'Hx', 'Ey');



