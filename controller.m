
fname = 'kap03/kap123as.ts';
[pos, Time, EMsigal] = TsReaderFunc(fname);
Signalset = SignalSetTransformer(Time(1,:),EMsigal{1});

fname = 'kap03/kap175as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsigal_ref{1});



% [Impedance,periods] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref);
% [Imp, err] = ImpedancePlotter(Impedance);
% DatHeaderWritter('try.dat', 20, 20)
% DatDataWriter('try.dat',periods,'127',0,0,[0,0,0],'TE',Imp,err)