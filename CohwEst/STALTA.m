function [ratio, event_indices] = STALTA(signal, sta_length, lta_length, threshold_ratio)
    % 初始化输出变量
    ratio = zeros(size(signal));
    event_indices = [];

    % 计算STA和LTA
    for i =  lta_length+1:length(signal)
        sta = mean(abs(signal(i-sta_length+1:i)));
        lta = mean(abs(signal(i-lta_length+1:i)));
        
        % 避免除以零
        if lta == 0
            ratio(i) = 0;
        else
            ratio(i) = sta / lta;
        end
        
        % 判断是否超过阈值
        if ratio(i) > threshold_ratio
            event_indices = [event_indices i];
        end
    end
end
