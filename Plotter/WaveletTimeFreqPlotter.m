function [] = WaveletTimeFreqPlotter(Time, periods,min_period,max_period, cfs, channel, lim)
%WAVELETTIMEFREQPLOTTER 此处显示有关此函数的摘要
%   此处显示详细说明
if ~exist('channel','var')
    channel = 'Hx';
end
if ~exist('lim','var')
    lim = prctile(abs(cfs(:)),80);
end
timeseries =  Time;
periods = seconds(periods);
cfs = cfs(periods>min_period & periods<max_period, :);
periods = log10(periods(periods>min_period & periods<max_period));
hp = pcolor(timeseries,periods,abs(cfs));
hp.EdgeAlpha = 0;
ylims = hp.Parent.YLim;
yticks = hp.Parent.YTick;
title(['WaveletAnalysis of ',channel]);
ylabel('Periods(s)');
xlabel('Time(d)');
cl = colorbar();
clim([0 lim])
cl.Label.String = "Power";
end

