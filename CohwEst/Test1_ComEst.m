run("AddPath.m")
run("ReadSignal.m");
index_start = 2;
index_end = 10;
b0_list = zeros(index_end-index_start+1,1);
bm_list = zeros(index_end-index_start+1,1);
bi_list = zeros(index_end-index_start+1,1);
b0err_list = zeros(index_end-index_start+1,1);
bmerr_list = zeros(index_end-index_start+1,1);
bierr_list = zeros(index_end-index_start+1,1);
p_list = zeros(index_end-index_start+1,1);
for index = index_start:index_end       
    Datapoints = zeros(0,2);
    wcohpoints = zeros(0,1);
    if pick_storm == 0
        for i =1:length(Nonstormtimes)
            nonstorm_index = i;
            run("GetEMChannel.m")
            
            run("CalculateCoherence.m")
            
            run("GetScore.m")
            
            s = 0;
            run("SelectSignalByScore.m")
            Datapoints = cat(1,Datapoints,X);
            wcohpoints = cat(1,wcohpoints,score_use);
        end
        X = Datapoints;
        score_use = wcohpoints;
    else
        run("GetEMChannel.m")
        
        run("CalculateCoherence.m")
        
        run("GetScore.m")
        
        s = 0;
        run("SelectSignalByScore.m")
    end
    
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
