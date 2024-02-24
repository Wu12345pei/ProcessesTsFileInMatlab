function [Timeseries_in_period] = TimeSeriesSelector(wcoh,period,Time)
%TIMESERIESSELECTOR 此处显示有关此函数的摘要
%   此处显示详细说明
load("matlab2.mat");
Timeseries_in_period = zeros(length(period), 2);
start_time = Time(1,1);
for i = 1:length(period)
    period_for_cal = round(period(i,1));
    coherence_at_this_period = wcoh(i, :);
    max_Vq_score = 0;
    for L = 50:5:500
        series_length = L*period_for_cal;
        lines_length = series_length/5;
        max_score = 0;
        for start_line = 1 : 10 : round((length(coherence_at_this_period) - lines_length)/10)*10-9
            score = mean(coherence_at_this_period(start_line:start_line+lines_length));
            if score > max_score
                max_score = score;
            end
        end
        if L>=50 && max_score>0.3
            column = round((L-50)/2)+1;
            row = round((max_score - 0.3)/0.01)+1;
            Vq_score = 10-Vq2(row,column);
        else
            Vq_score = 0;
        end
        Vq_score
        if Vq_score>max_Vq_score
            max_Vq_score = Vq_score;
            best_L = L;
        end
    end
    series_length = best_L*period_for_cal;
    lines_length = series_length/5;
    max_score = 0;
    for start_line = 1 : 10 : round((length(coherence_at_this_period) - lines_length)/10)*10-9
        score = mean(coherence_at_this_period(start_line:start_line+lines_length));
        if score > max_score
            max_score = score;
            best_start_line = start_line;
            best_end_line = best_start_line + lines_length;
        end
    end
    Timeseries_in_period(i,1) = best_start_line*5+start_time;
    Timeseries_in_period(i,2) = best_end_line*5+start_time;
end

