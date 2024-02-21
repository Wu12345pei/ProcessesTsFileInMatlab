[pos, Time, EMsignal] = TsReaderFunc(station_id);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
nonstorm_index = 1;