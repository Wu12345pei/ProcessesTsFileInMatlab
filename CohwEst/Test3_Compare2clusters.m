clc;
clear;
run("AddPath.m")
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% local_sig_points
station_id = 155;
run("ReadSignal.m");

pick_storm = 0;
nonstorm_index = 1;
run("GetEMChannel.m")

index = 10;
p(index)

run("CalculateCoherence.m")

run("GetScore.m")

s = 0.7;
run("SelectSignalByScore.m")

local_sig = cat(2,X,M',s_time);
%local_sig (hy,ex,hx,t)

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% ref_sig_points
station_id = 163;
run("ReadSignal.m");

pick_storm = 0;
nonstorm_index = 2;
run("GetEMChannel.m")

index = 10;
p(index)

run("CalculateCoherence.m")

run("GetScore.m")

s = 0;
run("SelectSignalByScore.m")

ref_sig = cat(2,X,M',s_time);
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% cluster
slope = atan(local_sig(:,2) ./ local_sig(:,1));
idx = kmeans(slope,2);
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% plot Data
scatter(local_sig(:,1),local_sig(:,2),"filled");
b=colorbar();
clim([0 4])
ylabel(b,'Direction_Consistence')
xlabel('Hy in frequency domain')
ylabel('Ex in frequency domain')
