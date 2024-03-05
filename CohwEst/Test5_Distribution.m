clc;
clear;
run("AddPath.m")

station_id = 163;
run("ReadSignal.m");

pick_storm = 1;

run("GetEMChannel.m")
        
index = 10;
p(index)

run("CalculateCoherence.m")

run("GetScore.m")

s = 0;
run("SelectSignalByScore.m")
X(:,3) = X(:,2)./X(:,1);
run("WLS_Coherence.m")

figure(1)
run("PlotData.m")

err = X(:,2) - bi*X(:,1);
figure(2)
scatter(X(:,1),abs(err),'filled')
