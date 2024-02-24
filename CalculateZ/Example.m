%% 建立用于计算Z的信号集
Signalset = SignalSetTransformer(time_serie, EMsignal);

%% 建立用于计算Z的参考信号集
Signalset_ref = SignalSetTransformer(time_serie_ref, EMsignal_ref);

%% 使用信号集和参考集计算Z
[Impedance, period_cal] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref, freq);
imp = double(Impedance.impedance);
Zxy = abs(imp(1, 1, 2));
