function [cutoff_value] = GetCutOffValue(f,cutoff)
%GETCUTOFFVALUE 此处显示有关此函数的摘要
%   此处显示详细说明
f_plot = f;
sorted_f = sort(f_plot(:), 'descend');
cumulative_f = cumsum(sorted_f) / sum(sorted_f);
cutoff_idx = find(cumulative_f >= cutoff, 1, 'first');
cutoff_value = sorted_f(cutoff_idx);
end

