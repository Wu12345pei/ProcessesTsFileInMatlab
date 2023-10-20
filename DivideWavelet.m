fname = 'kap03/kap145as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

[cfs_Hx, periods] = WaveletTransformer(StormEMsignal, 'Hx');
[cfs_Ey, periods] = WaveletTransformer(StormEMsignal, 'Ey');
cfs_ZTM = abs(cfs_Ey) ./ abs(cfs_Hx);
[wcoh,periods_wcoh,coi] = WaveletCoherence(StormEMsignal,'Hx','Ey');
periods_wcoh = seconds(periods_wcoh);
for i = 1:size(cfs_ZTM,1)
    for j = 1:size(cfs_ZTM,2)
        period = periods(i);
        [m,p] = min(abs(periods_wcoh - period));
        cfs_ZTM(i, j) = cfs_ZTM(i, j)^2*periods(i)*0.2;
        if wcoh(p,j)<0.8
            cfs_ZTM(i,j) = 0;
        end
    end
end
WaveletTimeFreqPlotter(Stormtime,periods,log10(cfs_ZTM+1),'Ey/Hx',4.5);
