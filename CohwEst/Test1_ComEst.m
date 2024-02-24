clc;
clear;
run("AddPath.m")
station_id = 148;
run("ReadSignal.m");
pick_storm = 0;
run("GetEMChannel.m")
index_start = 2;
index_end = 9;
b0_list = zeros(index_end-index_start+1,1);
bm_list = zeros(index_end-index_start+1,1);
bi_list = zeros(index_end-index_start+1,1);
b0err_list = zeros(index_end-index_start+1,1);
bmerr_list = zeros(index_end-index_start+1,1);
bierr_list = zeros(index_end-index_start+1,1);
p_list = zeros(index_end-index_start+1,1);
for index = index_start:index_end
       
        run("CalculateCoherence.m")
        
        run("GetScore.m")
        
        %run("CalculateRes.m")
        
        s = 0;
        run("SelectSignalByScore.m")
        
        run("OLS.m")
        run("WLS_Coherence.m")
        run("IRLS_Mest.m")
        b0_list(index-1) = b0;
        b0err_list(index-1) = error0;
        bm_list(index-1) = bm;
        bmerr_list(index-1) = errorm;
        bi_list(index-1) = bi;
        bierr_list(index-1) = errori;
        p_list(index-1) = p(index);
end
run("Plotresult.m")
