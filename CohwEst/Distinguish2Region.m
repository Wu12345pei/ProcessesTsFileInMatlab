Datapoints = zeros(0,2);
wcohpoints = zeros(0,1);
Datatime = zeros(0,1);
for i =1:length(Nonstormtimes)
    nonstorm_index = i;
    run("GetEMChannel.m")
    
    run("CalculateCoherence.m")
    
    run("GetScore.m")
    
    s = 0;
    run("SelectSignalByScore.m")
    Datapoints = cat(1,Datapoints,X);
    Datatime = cat(1,Datatime,s_time + 10000*nonstorm_index);
    wcohpoints = cat(1,wcohpoints,score_use);
end


%% try different k,plot, and initial
X = Datapoints;
score_use = wcohpoints;
run("OLS.m")
ini_split = b0;

below_or_upper = Datapoints(:,2) - Datapoints(:,1)*ini_split;
Region_A = Datapoints(find(below_or_upper<0),:);
score_A = wcohpoints(find(below_or_upper<0));
Time_A = Datatime(find(below_or_upper<0));

Region_B = Datapoints(find(below_or_upper>0),:);
score_B = wcohpoints(find(below_or_upper>0));
Time_B = Datatime(find(below_or_upper>0));
%% obtain sigma,calculate possibility
for ilt = 1:10
    X = Region_A;
    score_use = score_A;
    run("WLS_Coherence.m")
    b_RegionA = bi;
    res_RegionA = Res/sqrt(length(Region_A)-1);
    error_RegionA = errori;
    
    X = Region_B;
    score_use = score_B;
    run("WLS_Coherence.m")
    b_RegionB = bi;
    res_RegionB = Res/sqrt(length(Region_B)-1);
    error_RegionB = errori;
    
    RegionA_ResA = Region_A(:,2) - Region_A(:,1)*b_RegionA;
    MAD_A = mad(RegionA_ResA);
    RegionA_ResB = Region_A(:,2) - Region_A(:,1)*b_RegionB;
    RegionB_ResA = Region_B(:,2) - Region_B(:,1)*b_RegionA;
    RegionB_ResB = Region_B(:,2) - Region_B(:,1)*b_RegionB;
    
    RegionA_preserved = Region_A(RegionA_ResA<0,:);
    RegionA_preserved_score = score_A(RegionA_ResA<0);
    RegionA_preserved_time = Time_A(RegionA_ResA<0);
    RegionB_preserved = Region_B(RegionB_ResB>0,:);
    RegionB_preserved_score = score_B(RegionB_ResB>0);
    RegionB_preserved_time = Time_B(RegionB_ResB>0);

    X = RegionA_preserved;
    score_use = RegionA_preserved_score;
    run("WLS_Coherence.m")
    b_Ap = bi;
    preserved_Res_Ap = abs(RegionA_preserved(:,2) - b_Ap*RegionA_preserved(:,1));
    MAD_Ap = mad(preserved_Res_Ap);

    X = RegionB_preserved;
    score_use = RegionB_preserved_score;
    run("WLS_Coherence.m")
    b_Bp = bi;
    preserved_Res_Bp = abs(RegionB_preserved(:,2) - b_Bp*RegionB_preserved(:,1));
    MAD_Bp = mad(preserved_Res_Bp);
    MAD_Bp = min(4*MAD_Ap,MAD_Bp);

    points_tobe_classified = cat(1,Region_A(RegionA_ResA>0,:),Region_B(RegionB_ResB<0,:));
    points_tobe_classified_score = cat(1,score_A(RegionA_ResA>0),score_B(RegionB_ResB<0));
    points_tobe_classified_time = cat(1,Time_A(RegionA_ResA>0),Time_B(RegionB_ResB<0));
    
    points_tobe_classified_ResAp = abs(points_tobe_classified(:,2) - b_Ap*points_tobe_classified(:,1))/MAD_Ap;
    points_tobe_classified_ResBp = abs(points_tobe_classified(:,2) - b_Bp*points_tobe_classified(:,1))/MAD_Bp;
    points_tobe_classified_ResA = abs(cat(1,RegionA_ResA(RegionA_ResA>0),RegionB_ResA(RegionB_ResB<0))/MAD_A);

    points_belongto_A = zeros(length(points_tobe_classified_score),1);

    points_belongto_A(points_tobe_classified_ResAp - points_tobe_classified_ResBp < 0) = 1;
    points_belongto_A(points_tobe_classified_ResA>3)=0;

    Region_A = cat(1,RegionA_preserved,points_tobe_classified(points_belongto_A == 1,:));
    Time_A = cat(1,RegionA_preserved_time,points_tobe_classified_time(points_belongto_A == 1));
    score_A = cat(1,RegionA_preserved_score,points_tobe_classified_score(points_belongto_A == 1));
    Region_B = cat(1,RegionB_preserved,points_tobe_classified(points_belongto_A == 0,:));
    Time_B = cat(1,RegionB_preserved_time,points_tobe_classified_time(points_belongto_A == 0));
    score_B = cat(1,RegionB_preserved_score,points_tobe_classified_score(points_belongto_A == 0));
end