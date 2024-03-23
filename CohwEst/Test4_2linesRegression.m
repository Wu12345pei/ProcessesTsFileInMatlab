%% read data
clc;
clear;
run("AddPath.m")

station_id = 136;
run("ReadSignal.m");

pick_storm = 0;
index_start = 2;
index_end = 10;

bp_list = index_start:index_end;
p_list = index_start:index_end;
bperr_list = index_start:index_end;
for index = index_end:-1:index_start
    run("Distinguish2Region.m")
    if index < index_end
        doubled_time = intersect(latest_time,Time_A);
        all_time = union(latest_time,Time_A);
        if_chose_point = ismember(Datatime,all_time);
        Region_A_modi = Datapoints(if_chose_point==1,:);
        score_A_modi = wcohpoints(if_chose_point==1);
        Time_A_modi = Datatime(if_chose_point==1);
        do_not_downweight = ismember(Time_A_modi,doubled_time);
        score_A_modi(do_not_downweight==0) = score_A_modi(do_not_downweight==0)*0.5;
        X = Region_A_modi;
        score_use = score_A_modi;
        run("WLS_Coherence.m")
        b_RegionA = bi;
        error_RegionA = errori;
        latest_time = doubled_time;
    else
        latest_time = Time_A;
    end


    bp_list(index-index_start+1) = b_RegionA;
    p_list(index-index_start+1) = p(index);
    bperr_list(index-index_start+1) = error_RegionA;
end
pick_storm = 1;
run("Test1_ComEst.m")
bi1 = bi_list;
bi1err = bierr_list;

pick_storm = 0;
run("Test1_ComEst.m")
figure(1)
errorbar(p_list,bp_list,bperr_list);
hold on;
errorbar(p_list,bi1,bi1err)
hold on;
errorbar(p_list,bm_list,bmerr_list)
legend("Nonstormtime filtered Wcoh","Stormtime Wcoh","Nonstormtime Wcoh",'FontSize',15);
xlabel('Periods(s)','FontSize',20)
ylabel('Z Amp(mv/km/nT)','FontSize',20)
title(strcat('Station ',num2str(station_id),' Zxy'),"FontSize",20)
% index = 6;
% run("Distinguish2Region.m")
% figure(2)
% run("Plotregion.m")