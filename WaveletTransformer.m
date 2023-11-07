function [cfs, periods] = WaveletTransformer(EMsignal, channel)
%WAVELETTRANSFORMER 此处显示有关此函数的摘要
%   此处显示详细说明
all_channel = {'Hx', 'Hy', 'Hz', 'Ex', 'Ey'};
channel_id = find(strcmp(all_channel, channel));
EMsignal = EMsignal(:, channel_id);
fs = 0.2;
[cfs, f] = cwt(EMsignal, 'morse', fs);
periods = 1./f;
end