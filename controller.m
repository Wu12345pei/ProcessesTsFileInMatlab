% import calculate_time.*

fname = 'kap03/kap145as.ts';
[pos, Time, EMsigal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsigal);
% [cfs_storm, periods_storm] = WaveletTransformer(StormEMsignal, 'Hx');
% [cfs_nonstorm, periods_nonstorm] = WaveletTransformer(NonstormEMsignals{3, 1}, 'Hx');
% subplot(2, 1, 1);
% WaveletTimeFreqPlotter(Stormtime, periods_storm, cfs_storm);
% subplot(2, 1, 2);
% WaveletTimeFreqPlotter(Stormtime, periods_nonstorm, cfs_nonstorm);
WaveletCoherence(StormEMsignal, 'Hx', 'Hy');
%WaveletCoherence(NonstormEMsignals{1, 1}, 'Hx', 'Hy');


   