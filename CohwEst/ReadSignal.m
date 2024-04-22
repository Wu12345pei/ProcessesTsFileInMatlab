function [Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = ReadSignal(station_id)
    [~, Time, EMsignal] = TsReaderFunc(station_id);
    [Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
end