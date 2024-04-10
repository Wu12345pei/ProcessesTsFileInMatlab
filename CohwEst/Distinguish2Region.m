plo = 1;
k=1;
Datapoints = zeros(0,5);
wcohpoints = zeros(0,1);
Datatime = zeros(0,1);
if pick_storm == 0
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
elseif pick_storm == 3
        run("GetEMChannel.m")
        
        run("CalculateCoherence.m")
        
        run("GetScore.m")
        s = 0;
        run("SelectSignalByScore.m")
        Datapoints = cat(1,Datapoints,X);
        Datatime = cat(1,Datatime,s_time + 10000*nonstorm_index);
        wcohpoints = cat(1,wcohpoints,score_use);
end
run("AddGoodData.m")


select1 = Datapoints;
select2 = Datapoints;
for i = 1:2
    ureliable_thres = prctile(select1(:,3),95);
    ureliable_data = select1(select1(:,3)>ureliable_thres,:);
    
    waitingforselect_data = select1(select1(:,3)<ureliable_thres,:);
    waitingforselect_data=sortrows(waitingforselect_data,3,'descend');
    
    %use reliable data judge the rest
    for id = 1:length(waitingforselect_data(:,1))
        point = waitingforselect_data(id,:);
        judge_array = cat(1,point(5),ureliable_data(:,5));
        judge_array_weight = cat(1,point(4),ureliable_data(:,4));
        TF = Weighterout(judge_array,judge_array_weight.^k);
        if TF(1)==0
            ureliable_data = cat(1,ureliable_data,point);
        end
    end
    select1 = ureliable_data;
end
if plo
    figure(2)
    scatter(ureliable_data(:,1),ureliable_data(:,2),'b','filled');
    
    hold on;
end
for i = 1:2
    reliable_thres = prctile(select2(:,5),80);
    reliable_data = select2(select2(:,5)>reliable_thres,:);
    
    waitingforselect_data = select2(select2(:,5)<reliable_thres,:);
    waitingforselect_data=sortrows(waitingforselect_data,5,'descend');
    
    %use reliable data judge the rest
    for id = 1:length(waitingforselect_data(:,1))
        point = waitingforselect_data(id,:);
        judge_array = cat(1,point(3),reliable_data(:,3));
        judge_array_weight = cat(1,point(4),reliable_data(:,4));
        TF = Weighterout(judge_array,judge_array_weight.^k);
        if TF(1)==0
            reliable_data = cat(1,reliable_data,point);
        end
    end
    select2 = reliable_data;
end
if plo
    scatter(reliable_data(:,1),reliable_data(:,2),'r','filled');
    hold on;
end
unknown_data1 = intersect(reliable_data,ureliable_data,'rows');
U = union(reliable_data,ureliable_data,"rows");
reliable_data = setdiff(reliable_data,unknown_data1,"rows");
ureliable_data = setdiff(ureliable_data,unknown_data1,"rows");
unknown_data2 = setdiff(Datapoints,U,"rows");
unknown_data = union(unknown_data1,unknown_data2,"rows");
if plo
    scatter(unknown_data(:,1),unknown_data(:,2),'m','filled');
end
W1 = ureliable_data(:,4);
Cov_unreliable = cov(ureliable_data(:,3).*W1,ureliable_data(:,5).*W1); 
x1 = mean(ureliable_data(:,1).*W1/norm(W1));
y1 = mean(ureliable_data(:,2).*W1/norm(W1));
k1 = mean(ureliable_data(:,3).*W1/norm(W1));
q1 = mean(ureliable_data(:,5).*W1/norm(W1));
W2 = reliable_data(:,4);
Cov_reliable = cov(reliable_data(:,3).*W2,reliable_data(:,5).*W2);
x2 = mean(reliable_data(:,1).*W2/norm(W2));
y2 = mean(reliable_data(:,2).*W2/norm(W2));
k2 = mean(reliable_data(:,3).*W2/norm(W2));
q2 = mean(reliable_data(:,5).*W2/norm(W2));
for i = 1:length(unknown_data(:,1))
    coordinate_un = [unknown_data(i,3)-k1,unknown_data(i,5)-q1];
    coordinate_re = [unknown_data(i,3)-k2,unknown_data(i,5)-q2];
    unknown_data_dis_unre = sqrt(coordinate_un*Cov_unreliable*coordinate_un');
    unknown_data_dis_re = sqrt(coordinate_re*Cov_unreliable*coordinate_re');
    if unknown_data_dis_re < 0.02*unknown_data_dis_unre
        reliable_data = cat(1,reliable_data,unknown_data(i,:));
    else
        ureliable_data = cat(1,ureliable_data,unknown_data(i,:));
    end
end
if plo
    figure(3)
    scatter(ureliable_data(:,1),ureliable_data(:,2),'b','filled');
    hold on;
    scatter(reliable_data(:,1),reliable_data(:,2),'r','filled');
    figure(4)
    tiledlayout(2,1)
    ax1 = nexttile;
    Median_reliable = median(reliable_data(:,3));
    Median_reliable_X = median(reliable_data(:,1));
    R1 = reliable_data(:,3);
    histogram(R1,'BinWidth',Median_reliable/3,'Normalization','probability')
    xlabel('Pre selected','FontSize',20)
    ax2 = nexttile;
    G_a = Gooddata(Gooddata(:,1)<=2500*Median_reliable_X,:);
    G_b = Gooddata(Gooddata(:,3)<=2.5*Median_reliable,:);
    G = intersect(G_a,G_b,"rows");
    G1 = G(:,3);
    histogram(G1,'BinWidth',Median_reliable/3,'Normalization','probability')
    xlabel('Storm data','FontSize',20)
    linkaxes([ax1 ax2],'x')
    figure(5)
    histogram(ureliable_data(:,3),'BinWidth',Median_reliable/5,'Normalization','probability')
end