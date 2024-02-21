fname = 'kap03/kap145as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
Signalset = SignalSetTransformer(Stormtime, StormEMsignal);

fname = 'kap03/kap160as.ts';
[pos_ref, Time_ref, EMsignal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsignal_ref{1});
periods_for_cal = logspace(2,3,10);
freq = 1./periods_for_cal;

[Impedance, period_cal] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref, freq);
imp = double(Impedance.impedance);
err = double(Impedance.error);
ImpedancePlotter(imp, err, freq);
