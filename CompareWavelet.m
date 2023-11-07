fname = 'kap03/kap127as.ts';
[pos, Time, EMsigal] = TsReaderFunc(fname);

for i = 1:2
    Time_part = Time(i, :);
    EMsigal_part = EMsigal{i};
    [cfs_Hx, periods] = WaveletTransformer(EMsigal_part, 'Hx');
    [cfs_Ex, periods] = WaveletTransformer(EMsigal_part, 'Ex');
    figure(2*(i-1)+1)
    WaveletTimeFreqPlotter(Time_part,periods,cfs_Hx, 'Hx', 40);
    figure(2*(i-1)+2)
    WaveletTimeFreqPlotter(Time_part,periods,cfs_Ex, 'Ex', 150);
end
