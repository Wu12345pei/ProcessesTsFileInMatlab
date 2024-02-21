fname = 'kap03/kap133as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
noise = NonstormEMsignals{1};
fname = 'kap03/kap163as.ts';
for i = 1:5
StormEMsignal(:,i) = (StormEMsignal(:,i).*1 + noise(:,i).*2);
end
[pos_ref, Time_ref, EMsignal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsignal_ref{1});

figure(1)
[wcoh,periods,coi] = WaveletCoherence(StormEMsignal,'Hx','Ey');
periods = seconds(periods);
periods(find(periods>10000))=[];
score_p = zeros(length(periods),1);
for i = 1: length(score_p)
    score_p(i) = mean(wcoh(i,:))+0.3;
end
figure(2)
semilogx(periods,score_p,'.');
xlabel('Period(s)')
ylabel('Score')
periods(find(periods>2000))=[];
[Timeseries_in_period] = TimeSeriesSelector(wcoh,periods,Stormtime);
periods_for_cal = logspace(2,3.5,20);
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
    [Impedance, period_cal] = ImpedanceCalculaterBIRRP(signalset_for_cal, Signalset_ref, [freq_for_cal,0.001]);
    imp = double(Impedance.impedance);
    err = double(Impedance.error);
    Imp(i,:,:) = imp(1,:,:);
    Err(i,:,:) = err(1,:,:);
end

errorbar(periods_for_cal,abs(Imp(:,1,2)),Err(:,1,2),color='b')
hold on;
fname = 'kap03/kap133as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
for i = 1:5
StormEMsignal(:,i) = (StormEMsignal(:,i).*1 + noise(:,i).*2);
end
Signalset = SignalSetTransformer(Stormtime, StormEMsignal);

fname = 'kap03/kap163as.ts';
[pos_ref, Time_ref, EMsignal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsignal_ref{1});
periods_for_cal = logspace(2,3.5,20);
freq = 1./periods_for_cal;

[Impedance, period_cal] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref, freq);
imp_ori = double(Impedance.impedance);
err_ori = double(Impedance.error);
errorbar(periods_for_cal,abs(imp_ori(:,1,2)),err_ori(:,1,2),color='r')
xlabel('Period(s)')
ylabel('Zxy(mv/(km*nT))')