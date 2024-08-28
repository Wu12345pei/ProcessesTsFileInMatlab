function [wcoh,wcs,period,coi] = WaveletCoherence(EMsignal, channel1, channel2)
%WAVELETCOHERENCE 计算信号两个通道的小波相关
% 输入为EM信号，以及需要计算的两个通道
% 输出为小波相关，以及周期
delta_t = 5;
fs = 1/delta_t;
all_channel = {'Hx', 'Hy', 'Hz', 'Ex','Ey'};
channel_id1 = find(strcmp(all_channel, channel1));
channel_id2 = find(strcmp(all_channel, channel2));
EMsignal1 = EMsignal(:, channel_id1);
EMsignal2 = EMsignal(:, channel_id2);
[wcoh,wcs,period,coi] = wcoherence(EMsignal1, EMsignal2, seconds(delta_t));
% wcoherence(EMsignal1, EMsignal2, seconds(delta_t))
end