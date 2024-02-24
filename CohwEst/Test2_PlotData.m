clc;
clear;
run("AddPath.m")

station_id = 145;
run("ReadSignal.m");

pick_storm = 0;
nonstorm_index = 3;
run("GetEMChannel.m")

index = 10;
p(index)

run("CalculateCoherence.m")

run("GetScore.m")

s = 0.5;
run("SelectSignalByScore.m")

run("PlotData.m")
