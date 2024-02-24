clc;
clear;
run("AddPath.m")
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% local_sig_points
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
Mag_direction_consistance = zeros(length(local_sig),1);
dir_local = zeros(length(local_sig),2);
dir_ref = zeros(length(local_sig),2);
for i = 1:length(Mag_direction_consistance)
    dir_local(i,:) = [local_sig(i,3),local_sig(i,1)]/sqrt(local_sig(i,3)^2+local_sig(i,1)^2);
    j = local_sig(i,4);
    dir_ref(i,:) = [ref_sig(j,3),ref_sig(j,1)]/sqrt(ref_sig(j,3)^2+ref_sig(j,1)^2);
    Mag_direction_consistance(i) = dot(dir_local(i,:),dir_ref(i,:));
end


color_score = Mag_direction_consistance;

scatter(local_sig(:,1),local_sig(:,2),[],color_score,"filled");
b=colorbar();
ylabel(b,'Direction_Consistence')
xlabel('Hy in frequency domain')
ylabel('Ex in frequency domain')
clim([0.5 1])