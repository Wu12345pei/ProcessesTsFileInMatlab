function [position_list] = findposition(timepoint,timelist)
%FINDPOSITION 此处显示有关此函数的摘要
%   此处显示详细说明
time_start = timelist(:,1);
block = zeros(1,length(time_start));
for i = 1:length(time_start)
    for j = 1:length(timepoint)
        if i<length(time_start)
            if timepoint(j)>=time_start(i) && timepoint(j)<time_start(i+1)
                position_list(j) = timepoint(j) - time_start(i);
                block(i) = block(i) + 1;
            end
        elseif i == length(time_start)
                if timepoint(j)>=time_start(i)
                    position_list(j) = timepoint(j) - time_start(i);
                    block(i) = block(i) + 1;
                end
        end
        if i<length(time_start)
            if i>1 && timepoint(j)>=time_start(i) && timepoint(j)<time_start(i+1) 
                points_before = sum(block(1:i-1));
                position_list(j) = position_list(j) + position_list(points_before);
            end
        elseif i == length(time_start)
            if i>1 && timepoint(j)>=time_start(i)
                points_before = sum(block(1:i-1));
                position_list(j) = position_list(j) + position_list(points_before);
            end
        end
    end
end
position_list = round(position_list/5);
end

