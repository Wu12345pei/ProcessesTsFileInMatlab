function [cfs, periods] = WaveletTransformer(EMsignal, channel)
% WAVELETTRANSFORMER 将信号变为小波域
% 输入为EM信号以及希望转换的通道
% 输出为cfs(小波域信号)，以及变换之后的小波周期
all_channel = {'Hx', 'Hy', 'Hz', 'Ex', 'Ey'};
channel_id = find(strcmp(all_channel, channel));
EMsignal = EMsignal(:, channel_id);
fs = 0.2;
[cfs, f] = cwt(EMsignal, 'morse', fs);
periods = 1./f;
end