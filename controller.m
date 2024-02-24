<<<<<<< HEAD

fname = 'kap03/kap123as.ts';
[pos, Time, EMsigal] = TsReaderFunc(fname);
Signalset = SignalSetTransformer(Time(1,:),EMsigal{1});

fname = 'kap03/kap175as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsigal_ref{1});



% [Impedance,periods] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref);
% [Imp, err] = ImpedancePlotter(Impedance);
% DatHeaderWritter('try.dat', 20, 20)
=======
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
>>>>>>> 4b6c50e2f385fa5287298c4db6cb261a9dae6e24
% DatDataWriter('try.dat',periods,'127',0,0,[0,0,0],'TE',Imp,err)