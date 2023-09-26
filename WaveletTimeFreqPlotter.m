function [] = WaveletTimeFreqPlotter(Time, periods, cfs)
%WAVELETTIMEFREQPLOTTER 此处显示有关此函数的摘要
%   此处显示详细说明
delta_T = 5;
timeseries = 0 : delta_T : Time(1, 2) - Time(1, 1);
periods = log10(periods(1:100));
cfs = cfs(1:100, :);
hp = pcolor(timeseries,periods,abs(cfs));
hp.EdgeAlpha = 0;
ylims = hp.Parent.YLim;
yticks = hp.Parent.YTick;
cl = colorbar();
clim([0 20])
cl.Label.String = "Power";
end

