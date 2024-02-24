function [] = RawDataPlotter(time, EMsignal, channel, subfigure)
%RAWDATAPLOTTER 此处显示有关此函数的摘要
% 此函数用于绘制原始数据图像，输入为时间矩阵，电磁信号矩阵，希望绘制的分量频道，是否开启子图
% 此处显示详细说明，没有什么详细说明
delta_t = 5;
All_channel = {'Hx', 'Hy', 'Hz', 'Ex', 'Ey'};
for i = 1:size(time, 1)
    time_to_plot = (time(i, 1) : delta_t : time(i, 2));
    EM_signal_to_show = EMsignal{i, 1};
    for c = 1:length(channel)
        chan = channel{c};
        col = find(strcmp(All_channel, chan));
        if subfigure
            n_plots = length(channel);
            subplot(n_plots, 1, c);
        end
        title(chan);
        xlabel('days(since Oct.1)');
        ylabel('Intensity(nT or mV/km)')
        plot(time_to_plot/(3600*24), EM_signal_to_show(:, col), color=[1,0,0])
        hold on; 
    end
end

