fname = 'kap03/kap145as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
Signalset = SignalSetTransformer(Time(2,:), EMsignal{2});

fname = 'kap03/kap163as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(2,:),EMsigal_ref{2});
periods_for_cal = logspace(1.5,4,20);
periods_for_cal(20) = [];
periods_for_cal(19) = [];
freq = 1./periods_for_cal;

[Impedance, period_cal] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref, freq);
imp = double(Impedance.impedance);
err = double(Impedance.error);
ImpedancePlotter(imp, err, freq);
