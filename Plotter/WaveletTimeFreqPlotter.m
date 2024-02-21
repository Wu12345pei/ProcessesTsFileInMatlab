function [] = WaveletTimeFreqPlotter(Time, periods, cfs, channel, lim)
%WAVELETTIMEFREQPLOTTER 此处显示有关此函数的摘要
%   此处显示详细说明
if ~exist('channel','var')
    channel = 'Hx';
end
if ~exist('lim','var')
    lim = 50;
end
delta_T = 5;
timeseries =  Time(1, 1): delta_T : Time(1, 2);
timeseries = seconds(timeseries);
startdate = datetime('2003-10-01');
timeseries = startdate + timeseries;
periods = log10(periods(1:100));
cfs = cfs(1:100, :);
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

