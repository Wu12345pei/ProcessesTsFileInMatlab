function [Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal)
% 此函数用于将读取的数据分为磁暴时期数据和非磁暴时期数据，输入参数为台站记录时间片
% 段，台站记录的电磁信号数据，输出参数为非磁暴和磁暴时期的记录时间片段，非磁暴和磁
% 暴时期的记录数据。
% 输出输入格式一致，详情见函数TsReader
Nonstormtimes = zeros(0);
NonstormEMsignals  = {};
storm_lasting_days = 3;
hour_bias = 0;
storm_start_time = calculate_time(10, 29, hour_bias, 0, 0);
storm_lasting_time = storm_lasting_days*24*3600;
storm_end_time = storm_start_time + storm_lasting_time;
Stormtime  = [storm_start_time, storm_end_time];
for i = 1:size(Time,1)
    for j = 1:size(Time,2)
        Time_point = Time(i,j);
        if Time_point>storm_start_time && Time_point<storm_end_time
           if j == 2 && (Time_point - storm_start_time) > 3600*36
               Stormtime = [storm_start_time, Time_point];
           elseif j == 1 && (storm_end_time - Time_point) > 3600*36
               Stormtime = [Time_point, storm_end_time];
           end
        end
    end
end
storm_lasting_days = (Stormtime(2)-Stormtime(1))/24/3600;
StormEMsignal = DataSlicer(Time, EMsignal, Stormtime);
for interval_days = -5 * storm_lasting_days : storm_lasting_days : -1 * storm_lasting_days
    non_storm_start_times = storm_start_time + interval_days*24*3600;
    non_storm_end_times = non_storm_start_times + storm_lasting_days*24*3600;
    Nonstormtime = [non_storm_start_times, non_storm_end_times];
    NonstormEMsignal = DataSlicer(Time, EMsignal, Nonstormtime);
    if ~isempty(NonstormEMsignal)
        Nonstormtimes(end + 1, :) = Nonstormtime;
        NonstormEMsignals{end + 1} = NonstormEMsignal;
    end
end
for interval_days = 1 * storm_lasting_days : storm_lasting_days : 5 * storm_lasting_days
    non_storm_start_times = storm_start_time + interval_days*24*3600;
    non_storm_end_times = non_storm_start_times + storm_lasting_days*24*3600;
    Nonstormtime = [non_storm_start_times, non_storm_end_times];
    NonstormEMsignal = DataSlicer(Time, EMsignal, Nonstormtime);
    if ~isempty(NonstormEMsignal)
        Nonstormtimes(end + 1, :) = Nonstormtime;
        NonstormEMsignals{end + 1} = NonstormEMsignal;
    end
end
NonstormEMsignals = NonstormEMsignals';
end

