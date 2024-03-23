%% 基础用法，使用id 得到Non以及Storm的信号以及时间
[position, time_series, EMsignal] = TsReaderFunc(145);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(time_series, EMsignal);