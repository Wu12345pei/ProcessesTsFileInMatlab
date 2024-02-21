function [Slicedsignal] = DataSlicer(Time, EMsignal, time_to_extract)
%DATASLICER 此处显示有关此函数的摘要
%   此处显示详细说明
start_time = time_to_extract(1, 1);
end_time = time_to_extract(1, 2);
Time_section_num = size(Time, 1);
for i = 1:Time_section_num
    if Time(i, 1) <= start_time && Time(i, 2) >=  end_time
        EMsignal_start_line = round((start_time - Time(i, 1)) / 5 + 1);
        EMsignal_end_line = round((end_time - Time(i, 1)) / 5 + 1);
        Slicedsignal = EMsignal{i, 1};
        Slicedsignal = Slicedsignal(EMsignal_start_line:EMsignal_end_line, :);
        return;
    end
Slicedsignal = {};
end

