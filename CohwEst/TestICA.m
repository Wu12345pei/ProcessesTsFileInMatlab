
select1 = X;
select2 = X;
for i = 1:5
    ureliable_thres = prctile(select1(:,2),97);
    ureliable_data = select1(select1(:,2)>ureliable_thres,:);
    
    waitingforselect_data = select1(select1(:,2)<ureliable_thres,:);
    waitingforselect_data=sortrows(waitingforselect_data,2,'descend');
    
    %use reliable data judge the rest
    for id = 1:length(waitingforselect_data)
        point = waitingforselect_data(id,:);
        judge_array = cat(1,point(5),ureliable_data(:,5));
        TF = isoutlier(judge_array);
        if TF(1)==0
            ureliable_data = cat(1,ureliable_data,point);
        end
    end
    select1 = ureliable_data;
end
figure(2)
scatter(ureliable_data(:,1),ureliable_data(:,2),'b','filled');

hold on;







for i = 1:5
    reliable_thres = prctile(select2(:,1),97);
    reliable_data = select2(select2(:,1)>reliable_thres,:);
    
    waitingforselect_data = select2(select2(:,1)<reliable_thres,:);
    waitingforselect_data=sortrows(waitingforselect_data,'descend');
    
    %use reliable data judge the rest
    for id = 1:length(waitingforselect_data)
        point = waitingforselect_data(id,:);
        judge_array = cat(1,point(3),reliable_data(:,3));
        TF = isoutlier(judge_array);
        if TF(1)==0
            reliable_data = cat(1,reliable_data,point);
        end
    end
    select2 = reliable_data;
end

scatter(reliable_data(:,1),reliable_data(:,2),'r','filled');

hold on;

unknown_data1 = intersect(reliable_data,ureliable_data,'rows');
reliable_data = setdiff(reliable_data,unknown_data1,"rows");
ureliable_data = setdiff(ureliable_data,unknown_data1,"rows")
U = union(reliable_data,ureliable_data,"rows");
unknown_data2 = setdiff(X,U,"rows");

unknown_data = union(unknown_data1,unknown_data2,"rows");

scatter(unknown_data(:,1),unknown_data(:,2),'m','filled');

Cov_unreliable = cov(ureliable_data(:,[3,5])); 
x1 = mean(ureliable_data(:,1));
y1 = mean(ureliable_data(:,2));
k1 = mean(ureliable_data(:,3));
q1 = mean(ureliable_data(:,5));
Cov_reliable = cov(reliable_data(:,[3,5]));
x2 = mean(reliable_data(:,1));
y2 = mean(reliable_data(:,2));
k2 = mean(reliable_data(:,3));
q2 = mean(reliable_data(:,5));
for i = 1:length(unknown_data(:,1))
    coordinate_un = [unknown_data(i,3)-k1,unknown_data(i,5)-q1];
    coordinate_re = [unknown_data(i,3)-k2,unknown_data(i,5)-q2];
    unknown_data_dis_unre = sqrt(coordinate_un*Cov_unreliable*coordinate_un');
    unknown_data_dis_re = sqrt(coordinate_re*Cov_unreliable*coordinate_re');
    if unknown_data_dis_re < 0.1*unknown_data_dis_unre
        reliable_data = cat(1,reliable_data,unknown_data(i,:));
    else
        ureliable_data = cat(1,ureliable_data,unknown_data(i,:));
    end
end
figure(3)
scatter(ureliable_data(:,1),ureliable_data(:,2),'b','filled');
hold on;
scatter(reliable_data(:,1),reliable_data(:,2),'r','filled');