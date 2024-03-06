clc;
clear;
run("AddPath.m")

station_id = 133;
run("ReadSignal.m");

pick_storm = 0;
if pick_storm == 0
    for i =1:length(Nonstormtimes)
        nonstorm_index = i;
        run("GetEMChannel.m")
        
        index = 9;
        p(index)
        
        run("CalculateCoherence.m")
        
        run("GetScore.m")
        
        s = 0.8;
        run("SelectSignalByScore.m")
        X(:,3) = X(:,2)./X(:,1);
        run("PlotData.m")
        hold on;
    end
else
    run("GetEMChannel.m")
        
        index = 8;
        p(index)
        
        run("CalculateCoherence.m")
        
        run("GetScore.m")
        
        s = 0;
        run("SelectSignalByScore.m")
        X(:,3) = X(:,2)./X(:,1);
        run("PlotData.m")
end
