<<<<<<< HEAD
fname = 'kap03/kap160as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
figure(1)
[wcoh,period,coi] = WaveletCoherence(EMsignal{1},'Hx','Ey');
figure(2)
plot(0:5:Stormtime(2)-Stormtime(1),StormEMsignal(:,1))
title('Hx Time Sieres');
xlabel('Time(s)');
xlim([0 Stormtime(2)-Stormtime(1)]);
ylabel('Hx(nT)')
=======
fname = 'kap03/kap160as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
figure(1)
[wcoh,period,coi] = WaveletCoherence(EMsignal{1},'Hx','Ey');
figure(2)
plot(0:5:Stormtime(2)-Stormtime(1),StormEMsignal(:,1))
title('Hx Time Sieres');
xlabel('Time(s)');
xlim([0 Stormtime(2)-Stormtime(1)]);
ylabel('Hx(nT)')
>>>>>>> 4b6c50e2f385fa5287298c4db6cb261a9dae6e24
