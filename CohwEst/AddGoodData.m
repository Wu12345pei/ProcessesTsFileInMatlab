pick_storm = 1;
run("GetEMChannel.m")

run("CalculateCoherence.m")

run("GetScore.m")
s = 0;
run("SelectSignalByScore.m")

Gooddata = X;

Median_X = median(Datapoints(:,1));
Gooddata = Gooddata(Gooddata(:,1)<5*Median_X,:);
L_data = length(Datapoints);
L_gooddata = length(Gooddata);
percent_L = 0.5;

% Datapoints = cat(1,Datapoints,Gooddata(1:min(L_gooddata,round(percent_L*L_data)),:));
pick_storm = 0;
    