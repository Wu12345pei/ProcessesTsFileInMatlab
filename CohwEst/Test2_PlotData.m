
clc;
clear;
run("AddPath.m")

station_id = 148;
run("ReadSignal.m");
pick_storm = 0;
index = 10;
s = 0.7;
if pick_storm == 0
    Datapoints = zeros(0,5);
    wcohpoints = zeros(0,1);
    for i =1:length(Nonstormtimes)
        nonstorm_index = i;
        run("GetEMChannel.m")
        p(index)
        run("CalculateCoherence.m")
        run("GetScore.m")
        run("SelectSignalByScore.m")
        Datapoints = cat(1,Datapoints,X);
        wcohpoints = cat(1,wcohpoints,score_use);
        hold on;
    end
    X = Datapoints;
    score_use = wcohpoints;
else
    run("GetEMChannel.m")
    p(index)
    run("CalculateCoherence.m")
    run("GetScore.m")
    run("SelectSignalByScore.m")
end
X = X(X(:,1)<250,:);
score_use = score_use(X(:,1)<250);
run("PlotData.m")
