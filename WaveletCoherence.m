function [outputArg1,outputArg2] = WaveletCoherence(EMsignal, channel1, channel2)
%WAVELETCOHERENCE 此处显示有关此函数的摘要
%   此处显示详细说明
delta_t = 5;
fs = 1/delta_t;
all_channel = {'Hx', 'Hy', 'Hz', 'Ex', 'Ey'};
channel_id1 = find(strcmp(all_channel, channel1));
channel_id2 = find(strcmp(all_channel, channel2));
EMsignal1 = EMsignal(:, channel_id1);
EMsignal2 = EMsignal(:, channel_id2);
wcoherence(EMsignal1, EMsignal2, seconds(delta_t));
end