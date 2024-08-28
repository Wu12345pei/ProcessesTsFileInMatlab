function [cfs, period] = WaveletTransformer(EMsignal, channel)
%WAVELETTRANSFORMER 此处显示有关此函数的摘要
%   此处显示详细说明
all_channel = {'Hx', 'Hy', 'Hz', 'Ex', 'Ey'};
channel_id = find(strcmp(all_channel, channel));
EMsignal = EMsignal(:, channel_id);
ts = 5;
[cfs, period] = cwt(EMsignal, 'morse', seconds(ts));
