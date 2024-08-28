% 生成示例信号
function [volatility] = CalculateVolatility(Timearray,window_size)
sig = Timearray;
n = length(sig);
% 滑动窗口大小
% 初始化结果向量
volatility = zeros(1, n);



% 计算每个点的平稳性和波动性
for i = 1:n
    if mod(i,10) == 0
        % 定义窗口范围
        start_idx = max(1, i - floor(window_size / 2));
        end_idx = min(n, i + floor(window_size / 2));
        
        % 提取窗口内的数据
        window_data = sig(start_idx:end_idx);
        
        % 计算波动性（标准差）
        volatility(i) = std(window_data);
        
    elseif mod(i,10) ~= 0
        % 计算波动性（标准差）
        volatility(i) = NaN;
        
    end
end

volatility = fillmissing(volatility,'linear');
end