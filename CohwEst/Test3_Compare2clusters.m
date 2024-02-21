clc;
clear;
run("AddPath.m")

station_id = 148;
run("ReadSignal.m");

pick_storm = 0;
nonstorm_index = 3;
run("GetEMChannel.m")

index = 10;
p(index)

run("CalculateCoherence.m")

run("GetScore.m")

s = 0;
run("SelectSignalByScore.m")

%bar(X(:,1)./M')
histogram(X(:,1)./M')