fname = 'kap03/kap145as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

noise = NonstormEMsignals{1};
for i = 1:5
    StormEMsignal(:,i) = StormEMsignal(:,i) + noise(:,i);
end

Signalset = SignalSetTransformer(Stormtime,StormEMsignal);

fname = 'kap03/kap160as.ts';
[pos_ref, Time_ref, EMsignal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsignal_ref{1});

periods_for_cal = logspace(2,3,10);

[Impedance, period_cal] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref,1./periods_for_cal);
imp = double(Impedance.impedance);
err = double(Impedance.error);
ImpedancePlotter(imp,err,1./periods_for_cal);
% DatHeaderWritter('try.dat', 20, 20)
% DatDataWriter('try.dat',periods,'127',0,0,[0,0,0],'TE',Imp,err)