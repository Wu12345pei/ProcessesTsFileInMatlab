 function [time] = calculate_time(month, date, hour, minute, second)
%CALCULATE_TIME 此处显示有关此函数的摘要
%   此处显示详细说明
if month == 10
    days = date - 1;
elseif month == 11
    days = 31 + date - 1;
elseif month == 12
    days = 61 + date - 1;
end
hours = days * 24 + hour;
minutes = hours * 60 + minute;
seconds = minutes * 60 + second;
time = seconds;
end

