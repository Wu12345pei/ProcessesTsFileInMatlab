function[position, record_time_list, EM_signal_sliced] = TsReaderFunc(fname)
% 此函数用于读取Ts文件，输入为文件名称，输出为台站地址，记录的时间以及对应的EM磁场信息片段
% 输出格式：
% 台站地址为1*2矩阵，记录了台站的经纬度信息
% 记录时间为n*2的矩阵，记录了台站每段数据的开始和结束时间，单位为秒，起始时间为10月1日00：00
% EM信息为n*1的cell矩阵，每个元素为m*5的矩阵，分别为磁场xyz分量和电场xy分量的信息
fid = fopen(fname);
line = fgetl(fid);
read_date_start_line = false;
read_date_end_line = false;
record_time_list = zeros(4,2);
position = zeros(1,2);

% 读取时间信息
while ischar(line)
    if read_date_end_line
        break;
    end
    line = fgetl(fid);
    if contains(line, 'kap') && contains(line, '2003')
        read_date_start_line = true;
        datevalue = sscanf(line, '# %s  %d-%d-%d %d:%d:%d-%d-%d-%d %d:%d:%d');
        datevalue = datevalue(9:20);
        start_time = calculate_time(datevalue(2), datevalue(3), datevalue(4), datevalue(5), datevalue(6));
        end_time = calculate_time(datevalue(8), datevalue(9), datevalue(10), datevalue(11), datevalue(12)) + 1;
        for i = 1:4
            if all(record_time_list(i)==0)
                record_time_list(i,1) = start_time;
                record_time_list(i,2) = end_time;
                break
            end
        end
    else
        if read_date_start_line
            read_date_end_line = true;
        end
    end
end
% 读取经纬度信息
while ischar(line)
    line = fgetl(fid);
    if contains(line, 'LATITUDE')
        lat = sscanf(line, '%s  : %f');
        lat = lat(end);
        position(1, 1) = lat;
    end
    if contains(line, 'LONGITUDE')
        lon = sscanf(line, '%s : %f');
        lon = lon(end);
        position(1, 2) = lon;
    end
    if contains(line, 'INFO_END')
        break;
    end
end
% 读取头文件行数
frewind(fid);
head_lines = 0;
while ischar(line)
    line = fgetl(fid);
    head_lines = head_lines + 1;
    if contains(line, 'INFO_END')
        break
    end
end

%读取数据信息，除去无效行数
EM_signal = importdata(fname, ' ', head_lines);
EM_signal = EM_signal.data;
[nan_row, nan_col] = find(isnan(EM_signal));
EM_signal(nan_row, :) = [];

% 计算数据的切片位置
record_line_list = zeros(1,4);
for row = 1:4
    if ~all(record_time_list(row)==0)
        lines_num = round((record_time_list(row, 2) - record_time_list(row, 1)) / 5 + 1);
        record_line_list(row) = lines_num;
    end
end
record_line_list(record_line_list==0) = [];
record_time_list(all(record_time_list==0, 2), :) = [];

% 保证切片的行数总数加起来等于文件有效行数，修改对应的时间（一般而言是去除每段的最后一个时间点）
for i = 1:length(record_line_list)
    if sum(record_line_list) == length(EM_signal)
        break;
    end
    j = length(record_line_list) - i + 1;
    record_line_list(j) = record_line_list(j) - 1;
    record_time_list(j, end) = record_time_list(j, end) - 5;
end
% 切片操作
EM_signal_sliced = mat2cell(EM_signal, record_line_list);
end