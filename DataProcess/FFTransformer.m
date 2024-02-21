function [EMsignal_freq, freq] = FFTransformer(EMsignal)
%FFTRANSFORMER 此处显示有关此函数的摘要
%   此处显示详细说明
delta_T = 5;
fs = 1 / delta_T;
Windows = hamming(size(EMsignal, 1));
for i = 1:size(EMsignal,2)
    EMsignal(:, i) = Windows.*EMsignal(:, i);
end
Y = fft(EMsignal);
L = length(Y);
P2 = abs(Y / L);
P1 = P2(1 : L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
EMsignal_freq = P1;
freq = fs*(0:(L/2))/L;
end

