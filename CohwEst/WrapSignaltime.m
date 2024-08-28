function [Time_list] = WrapSignaltime(EMsignals,Time)
%WRAPSIGNALTIME 此处显示有关此函数的摘要
%   此处显示详细说明
length_sig = length(EMsignals);
Time_list = Time(1):5:Time(2); 
if length_sig == length(Time_list)
    Time_list = Time_list';
else
    error('Do not Match. Please Check Time')
end
end
