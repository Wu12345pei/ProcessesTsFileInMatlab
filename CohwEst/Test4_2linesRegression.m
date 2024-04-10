%% read data
clc;
clear;
run("AddPath.m")

station_id = 130;
run("ReadSignal.m");

pick_storm = 0;
index_start = 2;
index_end = 10;

bp_list = index_start:index_end;
p_list = index_start:index_end;
bperr_list = index_start:index_end;
for index = index_end:-1:index_start
    plo = 0;
    run("Distinguish2Region.m")
    score_use = reliable_data(:,4);
    X = reliable_data(:,1:2);
    run("WLS_Coherence.m")
    bp_list(index-index_start+1) = bi;
    bperr_list(index-index_start+1) = errori;
    p_list(index-index_start+1) = p(index);
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