function [Timeseries_in_period] = TimeSeriesSelector(wcoh,period,Time)
%TIMESERIESSELECTOR 此处显示有关此函数的摘要
%   此处显示详细说明
Timeseries_in_period = zeros(length(period), 2);
start_time = Time(1,1);
for i = 1:length(period)
    period_for_cal = round(period(i,1));
    coherence_at_this_period = wcoh(i, :);
    window_length = 50*period_for_cal+50000;
    n_timestep = window_length / 5;
    if n_timestep < length(coherence_at_this_period)
        score = zeros(1, length(coherence_at_this_period)-n_timestep+1);
        for j = 1:length(score)
            score(1, j) = mean(coherence_at_this_period(1,j:j+n_timestep-1));
        end
        [m,p] = max(score)
        Timeseries_at_this_period = [(p-1)*5 min([(p+n_timestep)*5,Time(1,2)-Time(1,1)])];
        Timeseries_in_period(i,:) = start_time + Timeseries_at_this_period; 
    else
        Timeseries_in_period(i,:) = Time;
    end
end

