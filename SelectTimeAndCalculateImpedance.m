fname = 'kap03/kap145as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

fname = 'kap03/kap163as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsigal_ref{1});

[wcoh,periods,coi] = WaveletCoherence(StormEMsignal,'Hx','Ey');
periods = seconds(periods);
periods(find(periods>10000))=[];
[Timeseries_in_period] = TimeSeriesSelector(wcoh,periods,Stormtime);
periods_for_cal = logspace(1.5,3,20);
Imp = zeros(length(periods_for_cal),2,2);
Err = zeros(length(periods_for_cal),2,2);
for i = 1:length(periods_for_cal)
    period_for_cal = periods_for_cal(i);
    freq_for_cal = 1/period_for_cal;
    m = min(abs(periods - period_for_cal));
    p = find(abs(periods - period_for_cal)==m);
    Timeseries_for_cal = Timeseries_in_period(p, :);
    data_for_cal = DataSlicer(Stormtime,{StormEMsignal},Timeseries_for_cal);
    signalset_for_cal = SignalSetTransformer(Timeseries_for_cal,data_for_cal);
    [Impedance, period_cal] = ImpedanceCalculaterBIRRP(signalset_for_cal, Signalset_ref, [freq_for_cal,0.0001]);
    imp = double(Impedance.impedance);
    err = double(Impedance.error);
    Imp(i,:,:) = imp(1,:,:);
    Err(i,:,:) = err(1,:,:);
end
ImpedancePlotter(Imp,Err,1./periods_for_cal);